package com.worldline.wldd.mq.ws.actions.entities;

import com.worldline.wldd.mq.ws.parameters.entities.Parameters;

import javax.persistence.*;
import java.util.Date;
import java.util.List;


@Entity // This tells Hibernate to make a table out of this class
public class Action {
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private Integer id;
    @Column(columnDefinition = "TEXT")
    private String name;
    @Column(columnDefinition = "TEXT")
    private String topic;
    @Column(columnDefinition = "TEXT")
    private String message;

    private Integer sort;

    private Integer adminId;

    private Integer lastEditionId;

    private Date lastEditionDate;

    @OneToMany(cascade=javax.persistence.CascadeType.REMOVE)
    private List<Parameters> parametersTopics;

    @OneToMany(cascade=javax.persistence.CascadeType.REMOVE)
    private List<Parameters> parametersMessages;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public List<Parameters> getParametersTopics() {
        return parametersTopics;
    }

    public void setParametersTopics(List<Parameters> parametersTopics) {
        this.parametersTopics = parametersTopics;
    }

    public List<Parameters> getParametersMessages() {
        return parametersMessages;
    }

    public void setParametersMessages(List<Parameters> parametersMessages) {
        this.parametersMessages = parametersMessages;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getAdminId() {
        return adminId;
    }

    public void setAdminId(Integer adminId) {
        this.adminId = adminId;
    }

    public Integer getLastEditionId() {
        return lastEditionId;
    }

    public void setLastEditionId(Integer lastEditionId) {
        this.lastEditionId = lastEditionId;
    }

    public Date getLastEditionDate() {
        return lastEditionDate;
    }

    public void setLastEditionDate(Date lastEditionDate) {
        this.lastEditionDate = lastEditionDate;
    }
}
