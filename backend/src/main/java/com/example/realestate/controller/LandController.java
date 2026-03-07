package com.example.realestate.controller;

import com.example.realestate.model.Land;
import com.example.realestate.repository.LandRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/lands")
@CrossOrigin(origins = "*")
public class LandController {

    @Autowired
    private LandRepository landRepository;

    @GetMapping
    public List<Land> getAllLands() {
        System.out.println(">>> LandController: Fetching all land submissions");
        return landRepository.findAll();
    }

    @PostMapping
    public Land submitLand(@RequestBody Land land) {
        System.out.println(">>> LandController: Submitting new land: " + land.getName());
        return landRepository.save(land);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Land> getLandById(@PathVariable Long id) {
        System.out.println(">>> LandController: Fetching land with ID: " + id);
        return landRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<Land> updateLand(@PathVariable Long id, @RequestBody Land landDetails) {
        System.out.println(">>> LandController: Updating land with ID: " + id);
        return landRepository.findById(id)
                .map(land -> {
                    land.setName(landDetails.getName());
                    land.setLocation(landDetails.getLocation());
                    land.setSize(landDetails.getSize());
                    land.setZoning(landDetails.getZoning());
                    land.setStage(landDetails.getStage());
                    return ResponseEntity.ok(landRepository.save(land));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteLand(@PathVariable Long id) {
        System.out.println(">>> LandController: Deleting land with ID: " + id);
        return landRepository.findById(id)
                .map(land -> {
                    landRepository.delete(land);
                    return ResponseEntity.ok().<Void>build();
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
