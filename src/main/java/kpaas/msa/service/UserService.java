package kpaas.msa.service;

import java.util.List;
import java.util.Map;

public interface UserService {

	public Map<String, Object> getUserList(Map<String, String> paramMap) throws Exception;
	
	public Map<String, Object> getUser(Map<String, String> paramMap) throws Exception;
	
	public Map<String, Object> checkLogin(Map<String, String> paramMap) throws Exception;

	public Map<String, Object> createUser(Map<String, String> paramMap) throws Exception;

	public Map<String, Object> updateUser(Map<String, String> paramMap) throws Exception;

	public Map<String, Object> deleteUser(Map<String, String> paramMap) throws Exception;

}
