enum Endpoints {
    private static let baseURL = ""
        
    static func bookSearch(ISBN: String) -> String {
        return "\(baseURL)/\(ISBN)"
    }
}
