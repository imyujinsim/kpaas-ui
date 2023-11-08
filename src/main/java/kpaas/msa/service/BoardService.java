package kpaas.msa.service;

import java.util.List;
import java.util.Map;

public interface BoardService {

	public Map<String, Object> getBoardList(Map<String, String> paramMap) throws Exception;

	public Map<String, Object> getBoardDetail(Map<String, String> paramMap) throws Exception;

	public Map<String, Object> getBoardCreate(Map<String, String> paramMap) throws Exception;

	public Map<String, Object> getBoardUpdate(Map<String, String> paramMap) throws Exception;

	public Map<String, Object> getBoardDelete(Map<String, String> paramMap) throws Exception;

}
