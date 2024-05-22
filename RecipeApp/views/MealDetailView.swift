import SwiftUI

struct MealDetailView: View {
    @StateObject var viewModel = MealViewModel()
    var mealId: String
    
    var body: some View {
        ScrollView {
            if let mealDetail = viewModel.selectedMealDetail {
                VStack(alignment: .leading) {
                    Text(mealDetail.name)
                                            .font(.system(size: 32, weight: .bold, design: .default))
                                            .foregroundColor(.blue)
                                            .padding(.vertical)
                                            .padding()
                    
                    AsyncImage(url: URL(string: mealDetail.thumbnail)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer().frame(height: 20)
                    
                    Text("Instructions")
                        .font(.system(size: 24, weight: .bold))
                    ForEach(mealDetail.instructions.split(separator: "\r\n"), id: \.self) { instruction in
                        Text("• \(instruction)")
                            .padding(.vertical, 2)
                            .font(.system(size: 18))
                    }
                    
                    Text("Ingredients")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.top)
                    
                    ForEach(mealDetail.ingredients.sorted(by: >), id: \.key) { ingredient, measure in
                        Text("\(ingredient): \(measure)")
                            .padding(.vertical, 2)
                            .font(.system(size: 18)) 
                    }
                }
                .padding()
            } else {
                ProgressView()
                    .onAppear {
                        viewModel.fetchMealDetail(mealId: mealId)
                    }
            }
        }
        .navigationTitle("Meal Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

