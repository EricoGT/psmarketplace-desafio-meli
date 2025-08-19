//
//  MainExecutor.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 16/08/25.
//

import Foundation

public final class MainExecutor {
    
    //MARK: - Properties:
    
    public typealias CompletionBlock = () -> Void
    public typealias CompletionConfirmationBlock = (_ endBlock: @escaping(CompletionBlock)) -> Void
    
    //MARK: - SYNC Methods:
    
    /** Este método executa o closure na main thread, fazendo as devidas verificações para tal. */
    public class func runSync(_ block: @escaping(CompletionBlock)) -> Void {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.sync {
                block()
            }
        }
    }
    
    /** O parâmetro **owner** será determinante na execução do closure. Este método torna desnecessário o uso de **[weak self]**. */
    public class func runSync(owner: AnyObject?,_ block: @escaping(CompletionBlock)) -> Void {
        if Thread.isMainThread {
            if let _ = owner {
                block()
            }
        } else {
            DispatchQueue.main.sync { [weak owner] in
                if let _ = owner {
                    block()
                }
            }
        }
    }
    
    //MARK: - ASYNC Methods:
    
    /** Aconselha-se o uso de **[weak self]** nos closures onde **self** for chamado. */
    public class func runAsync(_ block: @escaping(CompletionBlock)) -> Void {
        DispatchQueue.main.async {
            block()
        }
    }
    
    /** O parâmetro **owner** será determinante na execução do closure. Este método torna desnecessário o uso de **[weak self]**. */
    public class func runAsync(owner: AnyObject?,  _ block: @escaping(CompletionBlock)) -> Void {
        DispatchQueue.main.async { [weak owner] in
            if let _ = owner {
                block()
            }
        }
    }
    
    //MARK: - AFTER Methods:
    
    /** Versão retardável do método 'runAsync', utilizando 'owner'. */
    public class func runAfter(owner: AnyObject?, seconds: TimeInterval, _ block: @escaping(CompletionBlock)) -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak owner] in
            if let _ = owner {
                block()
            }
        }
    }
    
    /** Versão retardável do método 'runAsync'. */
    public class func runAfter(seconds: TimeInterval, _ block: @escaping(CompletionBlock)) -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            block()
        }
    }
    
    //MARK: - BACKGROUND Methods:
    
    /** Versão alternativa do método 'runAsync', permitindo a escolha da prioridade da tarefa.  */
    public class func runBackground(qos: DispatchQoS.QoSClass = .background, _ block: @escaping(CompletionBlock)) -> Void {
        DispatchQueue.global(qos: qos).async {
            block()
        }
    }
    
    /** Versão alternativa do método 'runAsync', utilizando 'owner', permitindo a escolha da prioridade da tarefa.  */
    public class func runBackground(owner: AnyObject?, qos: DispatchQoS.QoSClass = .background, _ block: @escaping(CompletionBlock)) -> Void {
        DispatchQueue.global(qos: qos).async { [weak owner] in
            if let _ = owner {
                block()
            }
        }
    }
    
    //MARK: - GROUP Methods:
    
    /** A implementação atual deste método exige que o chamador controle a disponibilidade dos recursos durante a execução dos closures. O uso do 'concurrentExecution', para real ganho de performance, só é aconselhável em tarefas complexas, com muitas iterações. */
    public class func runGroup(tasks: [CompletionConfirmationBlock], concurrentExecution: Bool = false, _ completion: @escaping(CompletionBlock)) -> DispatchGroup {
        
        let downloadGroup = DispatchGroup()
        
        if !concurrentExecution {
            
            //Tarefas são executadas em fila:
            
            for task in tasks {
                downloadGroup.enter()
                task({
                    downloadGroup.leave()
                })
            }
            
            downloadGroup.notify(queue: DispatchQueue.main) {
                completion()
            }
            
            return downloadGroup
            
        } else {
            
            //Tarefas executadas paralelamente:
            
            let _ = DispatchQueue.global(qos: .default)
            
            //O 'enter' precisa ocorrer fora do laço do 'concurrentPerform', pois é uma operação sequencial
            for _ in tasks {
                downloadGroup.enter()
            }
            
            DispatchQueue.concurrentPerform(iterations: tasks.count) { index in
                let confirmationBlock = tasks[index]
                confirmationBlock({
                    downloadGroup.leave()
                })
            }
            
            downloadGroup.notify(queue: DispatchQueue.main) {
                completion()
            }
            
            return downloadGroup
        }
    }
}
