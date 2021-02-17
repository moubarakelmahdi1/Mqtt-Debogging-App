package com.worldline.wldd.mq.ws.parameters.entities;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import javax.persistence.*;


@Entity // This tells Hibernate to make a table out of this class
public class Parameters {
    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private Integer id;
    @Column(columnDefinition = "TEXT")
    private String parameter;
    @Column(columnDefinition = "TEXT")
    private String parameterDefaultValue;
    private String type;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getParameter() {
        return parameter;
    }

    public void setParameter(String parameter) {
        this.parameter = parameter;
    }

    public String getParameterDefaultValue() {
        return parameterDefaultValue;
    }

    public void setParameterDefaultValue(String parameterDefaultValue) {
        this.parameterDefaultValue = parameterDefaultValue;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
