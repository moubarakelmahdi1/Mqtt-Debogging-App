package com.worldline.wldd.mq.ws.admin.repositories;

import java.util.List;

import com.worldline.wldd.mq.ws.admin.entities.Admin;
import org.springframework.data.repository.CrudRepository;


public interface AdminRepository extends CrudRepository<Admin, Long>{
    Admin findByDas(String das);
    Admin findByComplexId(String complexId);
    Admin findById(Integer id);
    List<Admin> findAllByOrderByLastName();
}
