import SwiftUI

struct ContentView: View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        
        if currentPage > totalPages {
            HomeView()
        }
        
        else {
            OnStartView()
        }
    }
}

var totalPages = 3

struct OnStartView: View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        ZStack{
            
            if currentPage == 1 {
                AppStartView(image: "HandPose", title: "Learn Finger alphabets", details: "Finger alphabets are an effective step toward acquiring sign language.")
            }
            
            if currentPage == 2 {
                AppStartView(image: "WorldMap", title: "Various Countries", details: "Finger alphabets are not a universal language and differs in different countries around the world.")
            }
            
            if currentPage == 3 {
                AppStartView(image: "Communication", title: "Expand World", details: "Communicate across borders by mastering finger alphabets from around the world!")
            }
        }
    }
}

struct AppStartView:View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    @Environment(\.displayScale) var displayScale: CGFloat
    
    var image: String
    var title: String
    var details: String
    
    var body: some View {
        
            VStack{
                HStack{
                    if currentPage == 1{
                        Text("Hello HandPose!")
                            .font(.system(size: 45))
                            .font(.title)
                            .fontWeight(.semibold)
                            .kerning(1.4)
                    }
                    else {
                        Button(action: {
                            currentPage -= 1
                        }, label: {
                            Image(systemName: "chevron.left")
                                .frame(width: 35, height: 35)
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(Color.black.opacity(0.4))
                        })
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                        currentPage = 4
                        
                    }, label: {
                        Text("Skip")
                            .font(.system(size: 35))
                            .fontWeight(.semibold)
                            .kerning(1.2)
                    })
                }.padding()
                    .foregroundStyle(.black)
                
                Spacer(minLength: 0)
                
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 16)
                    .frame(height: 600)
                
                Spacer(minLength: 80)
                
                Text(title)
                    .font(.system(size: 50, weight: .bold, design: .default))
                    .kerning(1.2)
                    .padding(.bottom, 5)
                    .foregroundStyle(.blue)
                
                Text(details)
                    .font(.system(size: 30, weight: .regular, design: .default))
                    .kerning(1.2)
                    .padding([.leading, .trailing])
                    .multilineTextAlignment(.center)
                
                Spacer(minLength: 0)
                
                HStack{
                    
                    if currentPage == 1 {
                        Color.blue.frame(height: 8 / displayScale)
                        Color.gray.frame(height: 8 / displayScale)
                        Color.gray.frame(height: 8 / displayScale)
                    }
                    else if currentPage == 2 {
                        Color.gray.frame(height: 8 / displayScale)
                        Color.blue.frame(height: 8 / displayScale)
                        Color.gray.frame(height: 8 / displayScale)
                    }
                    
                    else if currentPage == 3 {
                        Color.gray.frame(height: 8 / displayScale)
                        Color.gray.frame(height: 8 / displayScale)
                        Color.blue.frame(height: 8 / displayScale)
                    }
                }
                
                
                
                Button(action: {
                    
                    if currentPage <= totalPages {
                        currentPage += 1
                    } else {
                        currentPage = 1
                    }
                    
                }, label: {
                    
                    if currentPage == 3 {
                        Text("Get Started")
                            .fontWeight(.semibold)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.white)
                            .background(.blue)
                            .cornerRadius(40)
                            .padding(.horizontal, 16)
                        
                    } else {
                        Text("Next")
                            .fontWeight(.semibold)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.white)
                            .background(.blue)
                            .cornerRadius(40)
                            .padding(.horizontal, 16)
                        
                    }
                    
                })
        }
    }
}

