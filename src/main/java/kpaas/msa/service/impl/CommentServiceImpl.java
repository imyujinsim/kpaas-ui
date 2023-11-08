package kpaas.msa.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kpaas.msa.common.RestClient;
import kpaas.msa.service.CommentService;

@Service("commentService")
public class CommentServiceImpl implements CommentService {

	@Resource(name = "restClient")
	private RestClient restClient;
	
	@Value("#{apiProperties['ApiEndpoint']}")
	private String apiEndpoint;


	public Map<String, Object> getCommentList(Map<String, String> paramMap) throws Exception {
		Map<String, Object> result = restClient.get(apiEndpoint + "/comments/" + paramMap.get("boardSeq"), new HashMap<String, String>(), paramMap);
		return result;
	}

	public Map<String, Object> postComment(Map<String, String> paramMap) throws Exception {
		Map<String, Object> result = restClient.post(apiEndpoint + "/comments/", new HashMap<String, String>(), paramMap);
		return result;
	}

	public Map<String, Object> putComment(Map<String, String> paramMap) throws Exception {
		Map<String, Object> result = restClient.put(apiEndpoint + "/comments/" + paramMap.get("commentSeq"), new HashMap<String, String>(), paramMap);
		return result;
	}

	public Map<String, Object> deleteComment(Map<String, String> paramMap) throws Exception {
		Map<String, Object> result = restClient.delete(apiEndpoint + "/comments/" + paramMap.get("commentSeq"), new HashMap<String, String>());
		return result;
	}
}
