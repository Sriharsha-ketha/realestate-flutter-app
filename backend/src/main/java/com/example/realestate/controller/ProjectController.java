package com.example.realestate.controller;

import com.example.realestate.model.Project;
import com.example.realestate.repository.ProjectRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/projects")
@CrossOrigin(origins = "*")
public class ProjectController {

    @Autowired
    private ProjectRepository projectRepository;

    @GetMapping
    public List<Project> getAllProjects(@RequestParam(required = false) String theme) {
        System.out.println(">>> ProjectController: Fetching projects (Filter: " + theme + ")");
        List<Project> projects = projectRepository.findAll();
        if (theme != null && !theme.isEmpty()) {
            return projects.stream()
                    .filter(p -> theme.equalsIgnoreCase(p.getTheme()))
                    .collect(Collectors.toList());
        }
        return projects;
    }

    @PostMapping
    public Project createProject(@RequestBody Project project) {
        System.out.println(">>> ProjectController: Creating new project: " + project.getTitle());
        return projectRepository.save(project);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Project> getProjectById(@PathVariable Long id) {
        return projectRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<Project> updateProject(@PathVariable Long id, @RequestBody Project projectDetails) {
        return projectRepository.findById(id)
                .map(project -> {
                    project.setTitle(projectDetails.getTitle());
                    project.setLocation(projectDetails.getLocation());
                    project.setTheme(projectDetails.getTheme());
                    project.setIrr(projectDetails.getIrr());
                    project.setCapitalRequired(projectDetails.getCapitalRequired());
                    project.setCapitalRaised(projectDetails.getCapitalRaised());
                    project.setStage(projectDetails.getStage());
                    project.setImageUrl(projectDetails.getImageUrl());
                    project.setProjectedGrowth(projectDetails.getProjectedGrowth());
                    project.setDemandIndex(projectDetails.getDemandIndex());
                    project.setRiskProfile(projectDetails.getRiskProfile());
                    return ResponseEntity.ok(projectRepository.save(project));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProject(@PathVariable Long id) {
        return projectRepository.findById(id)
                .map(project -> {
                    projectRepository.delete(project);
                    return ResponseEntity.ok().<Void>build();
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
