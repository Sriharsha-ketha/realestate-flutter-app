package com.example.realestate.controller;

import com.example.realestate.model.Eoi;
import com.example.realestate.model.User;
import com.example.realestate.repository.EoiRepository;
import com.example.realestate.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/eois")
@CrossOrigin(origins = "*")
public class EoiController {

    @Autowired
    private EoiRepository eoiRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public List<Eoi> getAllEOIs() {
        return eoiRepository.findAll();
    }

    @PostMapping
    public ResponseEntity<?> submitEOI(@RequestBody Eoi eoi) {
        System.out.println(">>> EoiController: Submitting EOI for investor: " + eoi.getInvestorId() + " project: " + eoi.getProjectId());
        
        if (eoi.getInvestorId() == null || eoi.getProjectId() == null) {
            return ResponseEntity.badRequest().body(Map.of("error", "investorId and projectId are required"));
        }

        boolean eoiExists = eoiRepository.findByInvestorId(eoi.getInvestorId()).stream()
            .anyMatch(e -> e.getProjectId().equals(eoi.getProjectId()));
        
        if (eoiExists) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(Map.of("error", "EOI already submitted"));
        }
        
        Eoi savedEoi = eoiRepository.save(eoi);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedEoi);
    }

    @GetMapping("/investor/{investorId}")
    public List<Eoi> getEOIsByInvestor(@PathVariable Long investorId) {
        return eoiRepository.findByInvestorId(investorId);
    }

    // Goal: GET /api/eois/project/{projectId} -> Return all investors
    @GetMapping("/project/{projectId}")
    public List<Map<String, Object>> getInvestorsByProject(@PathVariable Long projectId) {
        List<Eoi> eois = eoiRepository.findByProjectId(projectId);
        return eois.stream().map(eoi -> {
            User user = userRepository.findById(eoi.getInvestorId()).orElse(null);
            Map<String, Object> map = new HashMap<>();
            map.put("id", eoi.getInvestorId());
            map.put("email", user != null ? user.getEmail() : "Unknown");
            map.put("status", eoi.getStatus());
            return map;
        }).collect(Collectors.toList());
    }
}
