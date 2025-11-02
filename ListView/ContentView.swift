//
//  ContentView.swift
//  ListView
//
//  Created by 田口怜央 on 2025/11/02.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FirstView()  // タスク一覧画面
        //SecondView()  // タスク追加画面
    }
}

// タスク一覧表示画面
struct FirstView: View {
    // "TasksData"というキーでUserDefaultsに保存されたものを監視
    @AppStorage("TasksData") private var tasksData = Data()
    
    // タスクを入れておくための配列
    @State var tasksArray: [Task] = []
    
    init() {
        if let decodedTasks = try? JSONDecoder().decode([Task].self, from: tasksData) {
            _tasksArray = State(initialValue: decodedTasks)
            print(tasksArray)
        }
    }
    var body: some View {
        
        NavigationStack {
            // タスク追加画面へのリンクボタン
            NavigationLink {
                SecondView(tasksArray: $tasksArray).navigationTitle(Text("Add Task"))
                    .navigationTitle(Text("Add Task"))
            } label: {
                Text("Add New Task")
                    .font(.system(size: 20, weight: .bold))
                    .padding()
            }
            
            // タスクリストを表示
        List {
            ForEach(tasksArray) { task in
                Text(task.taskItem)
                }
            
            .onMove { from, to in
                // リストを並べ替えたときに実行する処理
                replaceRow(from, to)
            }
            
            }
            // ナビゲーションバーに編集ボタンを追加
        .toolbar(content: {
            EditButton()
        })
            
            .navigationTitle("Task List")
        }
        .padding()

    }
    
    func replaceRow(_ from: IndexSet, _ to: Int) {
        tasksArray.move(fromOffsets: from, toOffset: to)
        if let encodedArray = try? JSONEncoder().encode(tasksArray){
            tasksData = encodedArray
        }
    }
}

// タスク追加画面
struct SecondView: View {
    @Environment(\.dismiss) private var dismiss  // 前の画面に戻る機能
    @State private var task: String = ""  // 入力されたテキストを保存
    @Binding var tasksArray: [Task]  // タスクの配列

    var body: some View {
        // タスク入力フィールド
        TextField("Enter your task", text: $task)
            .textFieldStyle(.roundedBorder)
            .padding()

        // 追加ボタン
        Button {
            addTask(newTask: task)  // タスクを追加
            task = ""  // 入力フィールドをクリア
            print(tasksArray)  // デバッグ用の出力
        } label: {
            Text("Add")
        }
        .buttonStyle(.borderedProminent)
        .tint(.red)
        .padding()

        Spacer()
    }

    // タスクを追加してUserDefaultsに保存する関数
    func addTask(newTask: String) {
        if !newTask.isEmpty {  // 空でない場合のみ実行
            let task = Task(taskItem: newTask)  // 新しいTaskオブジェクトを作成
            var array = tasksArray  // 現在の配列をコピー
            array.append(task)  // 新しいタスクを追加

            // JSONエンコードしてUserDefaultsに保存
            if let encodedData = try? JSONEncoder().encode(array) {
                UserDefaults.standard.setValue(encodedData, forKey: "TasksData")
                tasksArray = array  // 配列を更新
                dismiss()  // 前の画面に戻る
            }
        }
    }
}

//プレビュー用（開発時に画面を確認するため）
//#Preview("SecondView") {
//    SecondView()
//}

#Preview("FirstView") {
    FirstView()
}

#Preview {
    ContentView()
}
