package com.worldline.wldd.mq.ws.users.repositories;

import com.worldline.wldd.mq.ws.users.entities.UserGroups;
import org.springframework.data.repository.CrudRepository;
import org.springframework.web.bind.annotation.RequestParam;

public interface UserRepository extends CrudRepository<UserGroups, Integer>  {
    UserGroups findByName(String name);
}
