package com.Data_Access.demo.controller;
import com.Data_Access.demo.model.Company;
import com.Data_Access.demo.repository.CompanyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/companies")
public class CompanyController {

    @Autowired
    private CompanyRepository companyRepository;

    // Home Page
    @GetMapping("/")
    public String welcome() {
        return "<html><body><h1>WELCOME</h1></body></html>";
    }

    // Get All Companies
    @GetMapping
    public List<Company> getAllCompanies() {
        return companyRepository.findAll();
    }

    // Get a Company by ID
    @GetMapping("/{id}")
    public Company getCompanyById(@PathVariable Integer id) {
        return companyRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Company not found"));
    }

    // Create a Company
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Company createCompany(@RequestBody Company company) {
        return companyRepository.save(company);
    }

    // Update a Company
    @PutMapping("/{id}")
    public Company updateCompany(@PathVariable Integer id, @RequestBody Company companyDetails) {
        Company company = companyRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Company not found"));

        company.setName(companyDetails.getName());
        company.setDuration(companyDetails.getDuration());
        company.setProfile(companyDetails.getProfile());
        company.setStipend(companyDetails.getStipend());
        company.setWorkFromHome(companyDetails.getWorkFromHome());

        return companyRepository.save(company);
    }

    // Delete a Company
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteCompany(@PathVariable Integer id) {
        if (!companyRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Company not found");
        }
        companyRepository.deleteById(id);
    }
}
