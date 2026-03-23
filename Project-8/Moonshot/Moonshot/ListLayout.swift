//
//  ListLayout.swift
//  Moonshot
//
//  Created by Mylla on 05/03/26.
//

import SwiftUI

struct ListLayout: View {
    let missions: [Mission]
    let astronauts: [String: Astronaut]
    
    var body: some View {
        List {
            ForEach(missions) { mission in
                NavigationLink(value: mission) {
                    HStack {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        Spacer()
                        
                        VStack(alignment:.trailing) {
                            Text(mission.displayName)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(mission.formattedLaunchDate)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                }
                .listRowBackground(Color.darkBackground)
                .frame(maxWidth:.infinity)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden) 
        .background(.darkBackground)
        .navigationDestination(for: Mission.self) { mission in
            MissionView(mission: mission, astronauts: astronauts)
        }
    }
}

struct ListLayout_Previews: PreviewProvider {
    static var previews: some View {
        let missions: [Mission] = Bundle.main.decode("missions.json")
        let astronauts: [String:Astronaut] = Bundle.main.decode("astronauts.json")
        
        ListLayout(missions: missions, astronauts: astronauts)
    }
}
