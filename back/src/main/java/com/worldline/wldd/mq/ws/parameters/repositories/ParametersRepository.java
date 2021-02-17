package com.worldline.wldd.mq.ws.parameters.repositories;

import com.worldline.wldd.mq.ws.parameters.entities.Parameters;
import org.springframework.data.repository.CrudRepository;

public interface ParametersRepository extends CrudRepository<Parameters, Integer> {

}