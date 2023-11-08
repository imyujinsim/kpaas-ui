package kpaas.msa.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kpaas.msa.service.BoardService;

/**
 * @author JaemooSong
 *
 */
@Controller
public class BoardController {

	@Resource(name = "boardService")
	private BoardService boardService;
	
	
	@RequestMapping(value = "/board")	
	public String getBoardList(ModelMap model) throws Exception {
		
		Map<String, String> paramMap = new HashMap<String, String>();
		Map<String, Object> result = getBoardJSON(paramMap);
		
		model.addAttribute("resultData", result.get("resultData"));
		
		return "board";
	}

	@RequestMapping(value = "/boardDetail")	
	public String getBoardDetail(ModelMap model, @RequestParam Map<String, String> paramMap, @RequestParam(required = false) String boardSeq) throws Exception {
		
		if (boardSeq != null) {
			Map<String, Object> result = getBoardDetailJSON(paramMap);
			model.put("resultData", result.get("resultData"));
			model.put("type", "R");
		}
		
		return "boardDetail";
	}
	@RequestMapping(value = "/boardUpdate")	
	public String boardUpdate(ModelMap model, @RequestParam Map<String, String> paramMap, @RequestParam(required = false) String boardSeq) throws Exception {
		
		if (boardSeq != null) {
			Map<String, Object> result = getBoardDetailJSON(paramMap);
			model.put("resultData", result.get("resultData"));
		}
		
		return "boardUpdate";
	}
	@RequestMapping(value = "/boardInsert")	
	public String boardInsert() throws Exception {
		
		return "boardInsert";
	}

	@RequestMapping(value = "/boardJSON")
	@ResponseBody
	public Map<String, Object> getBoardJSON(@RequestParam Map<String, String> paramMap) throws Exception {
		
		Map<String, Object> result = boardService.getBoardList(paramMap);
		
		return result;
	}

	@RequestMapping(value = "/boardDetailJSON")
	@ResponseBody
	public Map<String, Object> getBoardDetailJSON(@RequestParam Map<String, String> paramMap) throws Exception {
		
		Map<String, Object> result = boardService.getBoardDetail(paramMap);
		
		return result;
	}

	@RequestMapping(value = "/boardCreateJSON")
	@ResponseBody
	public Map<String, Object> getBoardCreateJSON(@RequestParam Map<String, String> paramMap) throws Exception {
		
		Map<String, Object> result = boardService.getBoardCreate(paramMap);
		
		if("SUCCESS".equals(result.get("result"))) {
			Map<String, String> param = new HashMap<String, String>();
			
			param.put("boardSeq", result.get("boardSeq").toString());
			Map<String, Object> data = getBoardDetailJSON(param);
			result.put("resultData", data.get("resultData"));
			
		}
		
		return result;
	}

	@RequestMapping(value = "/boardUpdateJSON")
	@ResponseBody
	public Map<String, Object> getBoardUpdateJSON(@RequestParam Map<String, String> paramMap) throws Exception {
		
		Map<String, Object> result = boardService.getBoardUpdate(paramMap);
		
		if("SUCCESS".equals(result.get("result"))) {
			Map<String, String> param = new HashMap<String, String>();
			
			param.put("boardSeq", paramMap.get("boardSeq"));
			Map<String, Object> data = getBoardDetailJSON(param);
			result.put("resultData", data.get("resultData"));
			
		}
		
		return result;
	}

	@RequestMapping(value = "/boardDeleteJSON")
	@ResponseBody
	public Map<String, Object> getBoardDeleteJSON(@RequestParam Map<String, String> paramMap) throws Exception {
		
		Map<String, Object> result = boardService.getBoardDelete(paramMap);

		return result;
	}

}
