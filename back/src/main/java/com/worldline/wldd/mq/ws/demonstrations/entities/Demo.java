package com.worldline.wldd.mq.ws.demonstrations.entities;
import com.worldline.wldd.mq.ws.actions.entities.Action;
import com.worldline.wldd.mq.ws.users.entities.UserGroups;

import javax.persistence.*;
import java.util.List;

@Entity // This tells Hibernate to make a table out of this class
public class Demo{
    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private Integer id;
    private String name;

    @ManyToMany
    private List<UserGroups> user;

    @OneToMany(cascade=javax.persistence.CascadeType.REMOVE)
    @OrderBy("sort")
    private List<Action> action;

    private Integer adminId;


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

    public List<Action> getAction() {
        return action;
    }

    public void setAction(List<Action> action) {
        this.action = action;
    }

    public void setOneAction(Action action) {
        this.action.add(action);
    }

    public List<UserGroups> getUser() {
        return user;
    }

    public void setUser(List<UserGroups> user) {
        this.user = user;
    }

    public void setOneUser(UserGroups user) {
        this.user.add(user);
    }

    public Integer getAdminId() {
        return adminId;
    }

    public void setAdminId(Integer adminId) {
        this.adminId = adminId;
    }
}
