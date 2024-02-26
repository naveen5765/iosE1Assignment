import SwiftUI

struct ContentView: View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        if !vm.authenticated {
            VStack(spacing: 20) {
                Button("Logout", action: vm.logOut)
                    .tint(.red)
                    .buttonStyle(.bordered)
                List(vm.items, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text(item.title)
                        Text(item.url)
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                }.task {
                    await vm.fetchData()
                }
            }
        } else {
            ZStack {
//                Image("sky")
//                    .resizable()
//                    .cornerRadius(20)
//                    .ignoresSafeArea()
                
                Color.blue
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    Text("Login")
                        .foregroundColor(.black)
                        .font(.system(size: 50, weight: .medium, design: .rounded))
                        .underline()
                    
                    TextField("Username", text: $vm.username)
                        .textFieldStyle(.roundedBorder)
                        .padding(4)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    SecureField("Password", text: $vm.password)
                        .textFieldStyle(.roundedBorder)
                        .padding(4)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .privacySensitive()
                    HStack {
                        Spacer()
                        Button("Logon",role: .cancel, action: vm.authenticate)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                        Spacer()
                    }
                    Spacer()
                }
                .alert("Access denied", isPresented: $vm.invalid) {
                    Button("Dismiss", action: vm.logPressed)
                }
                .frame(width: 300)
                .padding()
            }
            .transition(.offset(x: 0, y: 850))
        }
    }
}

#Preview {
    ContentView()
}
