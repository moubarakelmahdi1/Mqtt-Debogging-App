package com.worldline.wldd.mq.ws.demonstrations.repositories;

import com.worldline.wldd.mq.ws.demonstrations.entities.Demo;
import com.worldline.wldd.mq.ws.actions.entities.Action;

import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface DemoRepository extends CrudRepository<Demo, Integer> {
    Demo findByName(String name);
}