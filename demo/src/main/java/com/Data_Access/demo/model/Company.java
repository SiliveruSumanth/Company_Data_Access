package com.Data_Access.demo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "companies")
public class Company {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // MySQL-friendly
    private Integer id;

    private String name;
    private Integer duration;
    private String profile;
    private Integer stipend;

    @Column(name = "work_from_home")
    private Boolean workFromHome;

    public Company() {}

    public Company(String name, Integer duration, String profile, Integer stipend, Boolean workFromHome) {
        this.name = name;
        this.duration = duration;
        this.profile = profile;
        this.stipend = stipend;
        this.workFromHome = workFromHome;
    }

    // getters & setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }

    public String getProfile() { return profile; }
    public void setProfile(String profile) { this.profile = profile; }

    public Integer getStipend() { return stipend; }
    public void setStipend(Integer stipend) { this.stipend = stipend; }

    public Boolean getWorkFromHome() { return workFromHome; }
    public void setWorkFromHome(Boolean workFromHome) { this.workFromHome = workFromHome; }
}
