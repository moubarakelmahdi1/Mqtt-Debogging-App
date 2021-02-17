package com.worldline.wldd.mq.ws.actions.repositories;

import com.worldline.wldd.mq.ws.actions.entities.Action;


import com.worldline.wldd.mq.ws.demonstrations.entities.Demo;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface ActionRepository extends CrudRepository<Action, Integer> {
    List<Action> findAllByOrderBySort();
    Action findBySort(Integer sort);

    Iterable<Action> findAllByName(String name);
}