package com.example.realestate.controller;

import com.example.realestate.model.Project;
import com.example.realestate.model.Eoi;
import com.example.realestate.service.ProjectService;
import com.example.realestate.repository.EoiRepository;
import com.example.realestate.repository.ProjectRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/projects")
@CrossOrigin(origins = "*")
public class ProjectController {

    private final ProjectService projectService;
    private final EoiRepository eoiRepository;
    private final ProjectRepository projectRepository;

    public ProjectController(ProjectService projectService, EoiRepository eoiRepository, ProjectRepository projectRepository) {
        this.projectService = projectService;
        this.eoiRepository = eoiRepository;
        this.projectRepository = projectRepository;
    }

    @PostMapping("/create")
    public ResponseEntity<Project> createProject(@RequestBody Project project) {
        Project saved = projectService.createProject(project);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @GetMapping
    public List<ProjectResponse> getAllProjects() {
        return projectService.getAllProjects().stream().map(project -> {
            String stageName = project.getStage() != null ? project.getStage().name() : null;
            double progressVal = projectService.calculateProjectProgress(stageName);
            int progress = (int) progressVal;
            return ProjectResponse.from(project, progress);
        }).toList();
    }

    @GetMapping("/investor/{investorId}")
    public List<ProjectResponse> getProjectsByInvestor(@PathVariable Long investorId) {
        System.out.println(">>> ProjectController: Fetching projects for investor: " + investorId);
        List<Eoi> eois = eoiRepository.findByInvestorId(investorId);
        List<Long> projectIds = eois.stream().map(Eoi::getProjectId).collect(Collectors.toList());
        
        return projectService.getAllProjects().stream()
                .filter(p -> projectIds.contains(p.getId()))
                .map(project -> {
                    String stageName = project.getStage() != null ? project.getStage().name() : null;
                    double progressVal = projectService.calculateProjectProgress(stageName);
                    return ProjectResponse.from(project, (int) progressVal);
                }).collect(Collectors.toList());
    }

    @GetMapping("/owner/{ownerId}")
    public List<ProjectResponse> getProjectsByOwner(@PathVariable Long ownerId) {
        System.out.println(">>> ProjectController: Fetching projects for owner: " + ownerId);
        return projectRepository.findByOwnerId(ownerId).stream().map(project -> {
            String stageName = project.getStage() != null ? project.getStage().name() : null;
            double progressVal = projectService.calculateProjectProgress(stageName);
            return ProjectResponse.from(project, (int) progressVal);
        }).toList();
    }

    @PutMapping("/update-stage/{projectId}")
    public ResponseEntity<?> updateProjectStage(@PathVariable Long projectId, @RequestParam String stage) {
        try {
            var updated = projectService.updateStage(projectId, stage);
            if (updated.isPresent()) {
                return ResponseEntity.ok(updated.get());
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ErrorResponse("Project not found", Instant.now().toString()));
            }
        } catch (IllegalArgumentException | IllegalStateException ex) {
            return ResponseEntity.badRequest().body(new ErrorResponse(ex.getMessage(), Instant.now().toString()));
        }
    }

    @GetMapping("/{projectId}/progress")
    public ResponseEntity<?> getProjectProgress(@PathVariable("projectId") Long projectId) {
        var opt = projectService.getProjectById(projectId);
        if (opt.isPresent()) {
            var project = opt.get();
            String stageName = project.getStage() != null ? project.getStage().name() : null;
            double progress = projectService.calculateProjectProgress(stageName);
            ProjectProgressResponse resp = new ProjectProgressResponse(project.getProjectName(), stageName, (int) progress);
            return ResponseEntity.ok(resp);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ErrorResponse("Project not found", Instant.now().toString()));
        }
    }
}
