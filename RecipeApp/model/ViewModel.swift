import Foundation
import Combine

class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var selectedMealDetail: MealDetail?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchMeals()
    }
    
    func fetchMeals() {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MealListResponse.self, decoder: JSONDecoder())
            .replaceError(with: MealListResponse(meals: []))
            .receive(on: DispatchQueue.main)
            .map { response in
                response.meals.sorted { $0.name < $1.name }
            }
            .assign(to: \.meals, on: self)
            .store(in: &cancellables)
    }
    
    func fetchMealDetail(mealId: String) {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MealDetailResponse.self, decoder: JSONDecoder())
            .replaceError(with: MealDetailResponse(meals: []))
            .receive(on: DispatchQueue.main)
            .map { $0.meals.first }
            .assign(to: \.selectedMealDetail, on: self)
            .store(in: &cancellables)
    }
}

