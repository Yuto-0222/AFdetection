//
//  HomeView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/13.
//

import SwiftUI

struct scrollPreKey:PreferenceKey{
    static var defaultValue:CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct Item: Identifiable{
    var id: Int
    var countryname: String
    var countryImage: Image
    var countrydescription: String
}

enum SamplePath {
    case pathA
    case pathB
    case pathC
    case pathD
    case pathE
}

struct HomeView: View {
    
    @State var isScroll = false
    @State private var navigatePath: [SamplePath] = []
    @State var isPresented:Bool = false
    
    var items: [Item] = [
        
        Item(id: 1, countryname: "American Sign Language", countryImage: Image("America"), countrydescription: "You can esaily learn American Sign Language.\nLet's have fun learning American Sign Language\ntogether"),
        
        Item(id: 2, countryname: "Japanese Sign Language", countryImage: Image("Japan"), countrydescription: "You can esaily learn Japanese Sign Language.\nLet's have fun learning Japanese Sign Language\ntogether"),
        
        Item(id: 3, countryname: "Chinese Sign Language", countryImage: Image("China"), countrydescription: "You can esaily learn Chinese Sign Language.\nLet's have fun learning Chinese Sign Language\ntogether"),
        
        Item(id: 4, countryname: "Spanish Sign Language", countryImage: Image("Spain"), countrydescription: "You can esaily learn Spanish Sign Language.\nLet's have fun learning Spanish Sign Language\ntogether"),
        
        Item(id: 5, countryname: "Mexican Sign Language", countryImage: Image("Mexico"), countrydescription: "You can esaily learn Mexican Sign Language.\nLet's have fun learning Mexican Sign Language\ntogether")
        
    ]
    
    var body: some View {
        NavigationStack(path: $navigatePath){
            ScrollView{
                getScrollOffsetReader()
                ForEach(items) { item in
                    Button(action: {
                        if item.id == 1 {
                            navigatePath.append(.pathA)
                            print(navigatePath)
                        } else if item.id == 2{
                            navigatePath.append(.pathB)
                            print(navigatePath)
                        } else if item.id == 3{
                            navigatePath.append(.pathC)
                            print(navigatePath)
                        } else if item.id == 4{
                            navigatePath.append(.pathD)
                            print(navigatePath)
                        } else if item.id == 5{
                            navigatePath.append(.pathE)
                            print(navigatePath)
                        }
                    },label: {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .foregroundStyle(Color("gray"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .shadow(color: .black.opacity(0.2), radius: 10, x:0, y:10)
                            .padding()
                            .overlay {
                                VStack(alignment: .leading){
                                    item.countryImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160, height: 100)
                                    Text(item.countryname)
                                        .frame(width: 510, height: 40)
                                        .font(.system(size: 40, weight: .bold, design: .default))
                                        .fontWeight(.heavy)
                                        .foregroundStyle(.black)
                                    VStack(alignment: .leading){
                                        Text(item.countrydescription)
                                            .font(.system(size: 25, weight: .semibold, design: .default))
                                            .foregroundStyle(.black)
                                    }.frame(width: 700, height: 90)
                                        .padding(.top)
                                }.navigationDestination(for: SamplePath.self) { value in
                                    
                                    switch value {
                                        
                                    case.pathA:
                                        ASLStartView(navigatePath: $navigatePath)
                                    case .pathB:
                                        JSLStartView(navigatePath:  $navigatePath)
                                    case .pathC:
                                        CSLStartView(navigatePath: $navigatePath)
                                    case .pathD:
                                        LSFStartView(navigatePath: $navigatePath)
                                    case .pathE:
                                        LSMStartView(navigatePath: $navigatePath)
                                    }
                                }
                            }
                    })
                }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(scrollPreKey.self, perform: { value in
                withAnimation(.default){
                    if value < 0{
                        isScroll = true
                    } else {
                        isScroll = false
                    }
                }
            })
            .safeAreaInset(edge: .top, content: {
                Color.clear
                    .frame(height: 75)
            })
            .overlay {
                ZStack{
                    Color.clear
                        .frame(height: isScroll ? 90 : 100)
                        .background(.ultraThinMaterial)
                        .opacity(isScroll ? 1 : 0)
                        .blur(radius: 0.5)
                        .edgesIgnoringSafeArea(.top)
                    HStack{
                        Text("Country Selection").bold()
                            .font(.system(size: isScroll ? 42: 52))
                            .frame(maxWidth:  .infinity,alignment: .leading)
                        
                    }
                    .offset(y: isScroll ? -30 : -25)
                    .padding(.horizontal)
                }
                .frame(maxHeight: .infinity,alignment:  .top)
            }
        }
    }
        
        func getScrollOffsetReader() -> some View{
            GeometryReader { geometry in
                //Text("\(geometry.frame(in: .named("scroll")).minY)")
                Color.clear.preference(key: scrollPreKey.self, value: geometry.frame(in: .named("scroll")).minY)
            }
        }
    }

