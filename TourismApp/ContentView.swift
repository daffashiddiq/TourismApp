//
//  ContentView.swift
//  TourismApp
//
//  Created by Daffashiddiq on 26/05/21.
//

import SwiftUI
import SDWebImageSwiftUI // Untuk menggunakan WebImage agar image bisa digunakan dengan remote, tidak perlu di-download

class ViewModel: ObservableObject{
    @Published var dataPlaces = TourPlaces(error: false, message: "success", count: 0)
    func loadData(){
        guard let url = URL(string: "https://tourism-api.dicoding.dev/list") else{ return}
        URLSession.shared.dataTask(with: url){data, _, error in
            DispatchQueue.main.async {
                if let data = data{
                    do{
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(TourPlaces.self, from: data)
                        self.dataPlaces = decodedData
                    }
                    catch{
                        print(error)
                    }
                }
            }
        }.resume()
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var isLinkActive = false
    var body: some View {
        NavigationView{
            Form{
                List(viewModel.dataPlaces.places, id: \.id){data in
                    NavigationLink(destination: DetailView(data : data)){
                    HStack{
                        WebImage(url: URL(string: data.image))
                            .resizable()
                            .frame(width: 80.0, height: 80.0)
                        VStack(alignment: .leading){
                            Text(data.name)
                                .font(.headline)
                            Text(data.address)
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 10.0)
                    }
                }
            }.onAppear(perform: {
                viewModel.loadData()
            })
            .navigationBarTitle("List")
            .navigationBarItems(trailing:
            NavigationLink(destination: ProfileView(), isActive:$isLinkActive){
                Button(action: {
                    self.isLinkActive = true
                }){
                    Image("profile-user")
                        .resizable()
                        .renderingMode(.original)
                }
                                    .padding(.all, 5.0)
                                    .frame(width: 48.0, height: 48.0)
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DetailView: View{
    var data: Place
    var body: some View{
            ScrollView {
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        ZStack(alignment: .bottomLeading) {
                            WebImage(url: URL(string: data.image))
                                .resizable()
                                .frame(width: 420.0, height: 400.0)

                            VStack(alignment: .leading){
                                Text(data.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(.bottom)
                                Text(data.address)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(.bottom)
                                Text(String(data.latitude))
                                    .font(.caption)
                                    .fontWeight(.light)
                                    .foregroundColor(Color.white)
                                    .padding(.bottom)
                                Text(String(data.longitude))
                                    .font(.caption)
                                    .fontWeight(.light)
                                    .foregroundColor(Color.white)
                            }
                            .padding([.leading, .bottom])
                            Spacer()
                        }
                        HStack{
                            Image("heart-2")
                                .resizable()
                                .frame(width: 20.0, height: 20.0)
                            Text(String(data.like))
                                .foregroundColor(Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0))
                                .padding(.trailing)
                        }
                    }
                    .padding(.bottom)
                    Text(data.description)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                }.navigationBarTitle("Detail")
        }
    }
}

struct ProfileView: View {
    var body: some View{
        VStack {
            Image("profile-user")
                .resizable()
                .frame(width: 150.0, height: 150.0)
            Text("Daffashiddiq")
                .font(.largeTitle)
            Text("daffashiddiq@gmail.com")
                .font(.headline)
        }
        .padding()
        Spacer()
            .navigationBarTitle("Profile")
    }
}



