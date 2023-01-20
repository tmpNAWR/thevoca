//
//  WordListView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

struct WordListView: View {
    @State private var selectedSegment: ProfileSection = .normal
    @State private var selectedWord: [UUID] = []
    
    // MARK: 단어 추가 버튼 관련 State
    @State var isShowingAddWordView: Bool = false
    @State var isShowingEditWordView: Bool = false
    
    // MARK: 단어장 편집모드 관련 State
    @State var isSelectionMode: Bool = false
    @State private var multiSelection: Set<String> = Set<String>()
    
//    @State var vocabulary: Vocabulary
//    @State var vocabulary: TempVocabulary = vocabularies[0]
    @State var vocabulary: Vocabulary
    
    @State var words: [Word] = [] {
        didSet {
            //삭제된 기록이 없는 단어장 filter
            filteredWords = words.filter({ $0.deletedAt == "" || $0.deletedAt == nil })
        }
    }
    
    @State var filteredWords: [Word] = []
    
    var body: some View {
        VStack{
            SegmentView(selectedSegment: $selectedSegment, selectedWord: $selectedWord)
            
            if filteredWords.count <= 0 {
                VStack(alignment: .center){
                    Spacer()
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("단어를 추가해주세요")
                        .font(.title3)
                    Spacer()
                }
                .foregroundColor(.gray)
            } else {
                WordsTableView(selectedSegment: $selectedSegment, selectedWord: $selectedWord, filteredWords: $filteredWords, isSelectionMode: $isSelectionMode, multiSelection: $multiSelection, nationality: Nationality(rawValue: vocabulary.nationality!) ?? .KO)
            }
            Text(multiSelection.description)
                
        }
        .navigationTitle(vocabulary.name ?? "unknown")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            words = vocabulary.words?.allObjects as! [Word]
        }
        .toolbar {
            // TODO: toolbar State 분기
            if !isSelectionMode { // 기존에 보이는 툴바
                ToolbarItem {
                    VStack(alignment: .center) {
                        Text("\(filteredWords.count)")
                            .foregroundColor(.gray)
                    }
                }
                // + 버튼
                ToolbarItem {
                    Button {
                        isShowingAddWordView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                // 햄버거 버튼
                ToolbarItem {
                    Menu {
                        Button {
                            isSelectionMode.toggle()
                        } label: {
                            HStack {
                                Text("단어장 편집하기")
                                Image(systemName: "checkmark.circle")
                            }
                        }
                        
                        Button {
                            words.shuffle()
                        } label: {
                            HStack {
                                Text("단어 순서 섞기")
                                Image(systemName: "shuffle")
                            }
                        }
                        
                        Button {
                            print("전체 단어 재생하기")
                        } label: {
                            HStack {
                                Text("전체 단어 재생하기")
                                Image(systemName: "play.fill")
                            }
                        }
                        .disabled(true)
                        
                        NavigationLink {
                            // ImportCSVFileView(vocabulary: vocabulary)
                        } label: {
                            HStack {
                                Text("단어 가져오기")
                                Image(systemName: "square.and.arrow.down")
                            }
                        }
                        
                        Button {
                            print("export")
                        } label: {
                            HStack {
                                Text("단어 리스트 내보내기")
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                        .disabled(true)
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            } else { // 새롭게 보이는 툴바
                ToolbarItem {
                    Button {
                        isSelectionMode.toggle()
                        multiSelection.removeAll()
                    } label: {
                        Text("취소")
                    }
                }
            }
        }
//        .toolbar {
//            ToolbarItem {
//                VStack {
//                    Text("\(multiSelection.count)")
//                        .foregroundColor(.gray)
//                }
//            }
//            ToolbarItem {
//                Button {
//                    isSelectionMode.toggle()
//                    multiSelection.removeAll()
//                } label: {
//                    isSelectionMode ? Text("취소") : Text("편집")
//                }
//            }
//        } // toolbar
    }
}

//struct WordListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
////            WordListView(vocabulary: vocabularies[0], filteredWords: JPWords)
//            WordListView(vocabulary: vocabularies[1], filteredWords: FRWords)
//        }
//    }
//}



