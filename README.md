# Vienna City Bike Stations App

This SwiftUI-based app provides a dynamic view of bike stations in Vienna, allowing users to sort and filter the list based on their preferences. It features modern Swift technologies and best practices for state management and asynchronous operations.

## Features

- **Segmented Control**: Switch between:
  - **Alphabetical**: Bike stations sorted by name.
  - **Vienna**: Stations located within Vienna.
  - **Nearby**: Stations sorted by proximity to the user's current location.

- **Bike Station Details**: Displays station name, available bikes, and empty slots.

- **Apple Maps Integration**: Tap on a station to view its location in Apple Maps.

- **Pull to Refresh**: Refresh the bike station list with a pull gesture.

## Technologies Used

- **SwiftUI**: For building the user interface, providing a declarative syntax for creating dynamic and responsive layouts.
  
- **Combine**: Utilized for handling asynchronous events and data streams. It allows for reactive programming, managing state changes, and reacting to user input or network responses.

- **Async/Await**: Employed to simplify asynchronous code, making network requests and data processing more readable and maintainable.

- **Protocols**: Implemented to define clear interfaces for services and state management, ensuring a modular and testable architecture.

- **Unit Tests**: Added to verify the correctness of individual components and logic, ensuring robustness and reliability of the application.

## Setup

1. **Clone the Repo**:
    ```bash
    git clone https://github.com/FarhanAmjad95/bike-stations-app.git
    ```

2. **Open and Run**:
   - Open `vienna-city-bike-stations-app.xcodeproj` in Xcode.
   - Build and run the app on an iOS simulator or device.

3. **Simulate Location**:
   - Use latitude `48.210033` and longitude `16.363449` to simulate a location in Vienna.

## License

MIT License. See [LICENSE](LICENSE) for details.

## Contact

For questions or feedback, email [farhan_amjad@ymail.com](mailto:farhan_amjad@ymail.com).
