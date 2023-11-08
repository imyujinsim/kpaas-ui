package kpaas.msa.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kpaas.msa.common.RestClient;
import kpaas.msa.service.BoardService;

@Service("boardService")
public class BoardServiceImpl implements BoardService {

	@Resource(name = "restClient")
	private RestClient restClient;
	
	@Value("#{apiProperties['ApiEndpoint']}")
	private String apiEndpoint;

	public Map<String, Object> getBoardList(Map<String, String> paramMap) throws Exception {
		Map<String, Object> result = restClient.get(apiEndpoint + "/board", new HashMap<String, String>(), paramMap);
		return result;
	}

	public Map<String, Object> getBoardDetail(Map<String, String> paramMap) throws Exception {
		Map<String, Object> result = restClient.get(apiEndpoint + "/board/" + paramMap.get("boardSeq"), new HashMap<String, String>(), paramMap);
		return result;
	}

	public Map<String, Object> getBoardCreate(Map<String, String> paramMap) throws Exception {
		Map<String, Object> result = restClient.post(apiEndpoint + "/board", new HashMap<String, String>(), paramMap);
		return result;
	}

	public Map<String, Object> getBoardUpdate(Map<String, String> paramMap) throws Exception {
		Map<String, Object> result = restClient.put(apiEndpoint + "/board/" + paramMap.get("boardSeq"), new HashMap<String, String>(), paramMap);
		return result;
	}

	public Map<String, Object> getBoardDelete(Map<String, String> paramMap) throws Exception {
		Map<String, Object> result = restClient.delete(apiEndpoint + "/board/" + paramMap.get("boardSeq") + "/" + paramMap.get("writeUserId"), new HashMap<String, String>());
		return result;
	}

}
