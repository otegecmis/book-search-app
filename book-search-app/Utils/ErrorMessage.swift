enum ErrorMessage: String, Error {
    case unableToFavorite = "An error occurred while trying to favorite this book. Please try again."
    case alreadyInFavorites = "This book is already in your favorites."
}
