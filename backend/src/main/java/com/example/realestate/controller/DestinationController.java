package com.example.realestate.controller;

import com.example.realestate.model.Destination;
import com.example.realestate.repository.DestinationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/destinations")
@CrossOrigin(origins = "*")
public class DestinationController {

    @Autowired
    private DestinationRepository repo;

    // Tourism destinations map: State/Region -> List of Tourist Destinations
    private static final Map<String, List<String>> TOURISM_MAP = new LinkedHashMap<>();

    static {
        TOURISM_MAP.put("Tamil Nadu", List.of("Ooty"));
        TOURISM_MAP.put("Uttar Pradesh", List.of("Ayodhya"));
        TOURISM_MAP.put("Uttarakhand", List.of("Kedarnath", "Badrinath", "Nainital"));
        TOURISM_MAP.put("West Bengal", List.of("Darjeeling"));
        TOURISM_MAP.put("Jammu & Kashmir", List.of("Gulmarg"));
        TOURISM_MAP.put("Andaman & Nicobar Islands", List.of("Andaman", "Radhanagar Beach"));
        TOURISM_MAP.put("Goa", List.of("Baga Beach"));
        TOURISM_MAP.put("Himachal Pradesh", List.of("Shimla", "Manali"));
        TOURISM_MAP.put("Karnataka", List.of("Coorg", "South Karnataka"));
        TOURISM_MAP.put("Kerala", List.of("Munnar"));
        TOURISM_MAP.put("Maharashtra", List.of("Shirdi Sai Baba Temple"));
        TOURISM_MAP.put("Odisha", List.of("Jagannath Temple", "Konark Sun Temple"));
        TOURISM_MAP.put("Rajasthan", List.of("Jaipur"));
        TOURISM_MAP.put("Andhra Pradesh", List.of("Tirumala", "Araku Valley", "Surya Lanka / Bapatla Beach"));
    }

    /**
     * GET /api/destinations/tourism
     * Returns the complete tourism destinations map (State/Region -> Tourist Destinations).
     * Used by frontend for hierarchical filtering.
     */
    @GetMapping("/tourism")
    public ResponseEntity<Map<String, List<String>>> getTourismDestinations() {
        return ResponseEntity.ok(TOURISM_MAP);
    }

    /**
     * GET /api/destinations/all
     * Returns all destination entities from the database.
     */
    @GetMapping("/all")
    public List<Destination> getDestinations() {
        return repo.findAll();
    }
}
