//
//  Location.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//


struct Location: Codable {
    let street: Street
    let city, state, country: String
    let postcode: String
    let coordinates: Coordinates
    let timezone: Timezone
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        street = try container.decode(Street.self, forKey: .street)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        timezone = try container.decode(Timezone.self, forKey: .timezone)

        // Handle postcode as Int or String
        if let intPostcode = try? container.decode(Int.self, forKey: .postcode) {
            self.postcode = String(intPostcode)
        } else if let stringPostcode = try? container.decode(String.self, forKey: .postcode) {
            postcode = stringPostcode
        } else {
            postcode = ""
        }
    }
    
    init(street: Street, city: String, state: String, country: String, postcode: String, coordinates: Coordinates, timezone: Timezone) {
        self.street = street
        self.city = city
        self.state = state
        self.country = country
        self.postcode = postcode
        self.coordinates = coordinates
        self.timezone = timezone
    }
}
