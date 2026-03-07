package com.example.realestate.controller;

import com.example.realestate.model.Project;
import com.example.realestate.repository.ProjectRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/projects")
@CrossOrigin(origins = "*")
public class ProjectController {

    @Autowired
    private ProjectRepository projectRepository;

    @GetMapping
    public List<Project> getAllProjects() {
        System.out.println(">>> ProjectController: Fetching all projects");
        return projectRepository.findAll();
    }

    @PostMapping
    public Project createProject(@RequestBody Project project) {
        System.out.println(">>> ProjectController: Creating new project: " + project.getTitle());
        return projectRepository.save(project);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Project> getProjectById(@PathVariable Long id) {
        System.out.println(">>> ProjectController: Fetching project with ID: " + id);
        return projectRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<Project> updateProject(@PathVariable Long id, @RequestBody Project projectDetails) {
        System.out.println(">>> ProjectController: Updating project with ID: " + id);
        return projectRepository.findById(id)
                .map(project -> {
                    project.setTitle(projectDetails.getTitle());
                    project.setLocation(projectDetails.getLocation());
                    project.setIrr(projectDetails.getIrr());
                    project.setCapitalRequired(projectDetails.getCapitalRequired());
                    project.setCapitalRaised(projectDetails.getCapitalRaised());
                    project.setStage(projectDetails.getStage());
                    project.setImageUrl(projectDetails.getImageUrl());
                    return ResponseEntity.ok(projectRepository.save(project));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProject(@PathVariable Long id) {
        System.out.println(">>> ProjectController: Deleting project with ID: " + id);
        return projectRepository.findById(id)
                .map(project -> {
                    projectRepository.delete(project);
                    return ResponseEntity.ok().<Void>build();
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
