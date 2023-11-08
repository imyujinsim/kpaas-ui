package kpaas.msa.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.http.HttpEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;

import kpaas.msa.common.CommonUtil;
import kpaas.msa.service.CommentService;

/**
 * @author Jae Young Im
 *
 */
@Controller
public class CommentController {

	@Resource(name = "commentService")
	private CommentService commentService;

	private static String SUCCESS = "SUCCESS";
	
	@RequestMapping(value = "/comments", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getComments(@RequestParam(required = true) Integer boardSeq) {
		
		Map<String, String> paramMap = new HashMap<String, String>();
		Map<String, Object> result = new HashMap<String, Object>();


		paramMap.put("boardSeq", boardSeq.toString());
		// Select CommentList
		try {
			result = commentService.getCommentList(paramMap);
		} catch (Exception e) {
			result.put("result", "ERROR");
			result.put("errMsg", e.getMessage());
			e.printStackTrace();
		}
		
		return result;
	}

	@RequestMapping(value = "/comments", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> postComment(@RequestParam Map<String, String> paramMap) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> resultData = new HashMap<String, Object>();

		// parameter Setting
		try {

			String comment = paramMap.get("comment");
			String writeUserId = paramMap.get("writeUserId");
			String writeUserName = paramMap.get("writeUserName");
			
			// null String check
			if(CommonUtil.isEmptyString(comment)) {
				throw new Exception("코멘트 내용은 필수 입력값입니다.");
			} else if(CommonUtil.isEmptyString(writeUserId)) {
				throw new Exception("사용자 ID는 필수 입력값입니다.");
			} else if(CommonUtil.isEmptyString(writeUserName)) {
				throw new Exception("사용자 명은 필수 입력값입니다.");
			}

		} catch (Exception e) {
			result.put("result", "ERROR");
			result.put("errMsg", e.getMessage());
			e.printStackTrace();

			return result;
		}
		
		try {
			
			result = commentService.postComment(paramMap);
			if(!SUCCESS.equals(result.get("result"))) {
				throw new Exception("코멘트 생성에 실패하였습니다.");
			}
			
			resultData.put("commentSeq", paramMap.get("commentSeq"));

		} catch (Exception e) {
			result.put("result", "ERROR");
			result.put("errMsg", e.getMessage());
			e.printStackTrace();
		}
		
		return result;
	}

	@RequestMapping(value = "/updateComment")
	@ResponseBody
	public Map<String, Object> putComment(@RequestParam Map<String, String> paramMap) {
		
		Map<String, Object> result = new HashMap<String, Object>();

		// parameter Setting
		try {

			String comment = paramMap.get("comment");
			
			// 수정 요청 Data가 없는 경우
			if(CommonUtil.isEmptyString(comment)) {
				throw new Exception("코멘트 값은 필수 값입니다.");
			}
			
		} catch (Exception e) {
			result.put("result", "ERROR");
			result.put("errMsg", e.getMessage());
			e.printStackTrace();

			return result;
		}
		
		try {
			result = commentService.putComment(paramMap);
			if(!SUCCESS.equals(result.get("result"))) {
				throw new Exception("코멘트 수정에 실패하였습니다.");
			}
			
		} catch (Exception e) {
			result.put("result", "ERROR");
			result.put("errMsg", e.getMessage());
			e.printStackTrace();
		}
		
		return result;
	}

	@RequestMapping(value = "/deleteComment")
	@ResponseBody
	public Map<String, Object> deleteComment(@RequestParam Map<String, String> paramMap) {
		
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			result = commentService.deleteComment(paramMap);
			if(!SUCCESS.equals(result.get("result"))) {
				throw new Exception("코멘트 삭제에 실패하였습니다.");
			}
			
		} catch (Exception e) {
			result.put("result", "ERROR");
			result.put("errMsg", e.getMessage());
			e.printStackTrace();
		}
		
		return result;
	}

}
