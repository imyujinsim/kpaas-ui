package kpaas.msa.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kpaas.msa.service.UserService;

/**
 * @author Jae Young Im
 *
 */
@Controller
public class UserController {

	@Resource(name = "userService")
	private UserService userService;
	
	@Autowired
	private StringRedisTemplate redisTemplate;
	
	private static String SUCCESS = "SUCCESS";
	private static String ERROR = "ERROR";
	private static String SESSION_ID = "session_id";
	private static String USER_ID = "user_id";
	private static String USER_NAME = "user_name";
	
	@RequestMapping(value = "/user/join")	
	public String getJoinPage() throws Exception {
		return "join";
	}
	
	@RequestMapping(value = "/user/login")	
	public String getLoginPage() throws Exception {
		return "login";
	}

	@RequestMapping(value = "/user/createUser")
	@ResponseBody
	public Map<String, Object> createUser(@RequestParam Map<String, String> paramMap) throws Exception {
		Map<String, Object> result = userService.createUser(paramMap);
		return result;
	}

	
	@RequestMapping(value = "/user/userInfo")	
	public String getUser(ModelMap model, @RequestParam Map<String, String> paramMap, @RequestParam(required = false) String userId) throws Exception {
		
		if (userId != null) {
			Map<String, Object> result = userService.getUser(paramMap);
			model.put("resultData", result.get("resultData"));
		}
		
		return "userInfo";
	}
	
	@RequestMapping(value = "/user/loginUser", method = RequestMethod.POST)	
	@ResponseBody
	public  Map<String, Object> loginUser(@RequestParam Map<String, String> paramMap
							, HttpServletRequest request
							, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String sessionId = (String)session.getAttribute(SESSION_ID);
		ValueOperations<String, String> pos = redisTemplate.opsForValue();
		String userId = paramMap.get("userId");
		
		Map<String, Object> retMap = new HashMap<String, Object>();
		
		retMap.put("result", this.ERROR);
		System.out.println("SESSION_ID : " + sessionId);
		
		if (userId != null) {
			if( sessionId == null || "".equals(sessionId) || !sessionId.equals(pos.get(userId))) {
				Map<String, Object> result = userService.checkLogin(paramMap);
				Map<String, Object> userMap = (Map<String,Object>) result.get("resultData");
				String newSessionId = this.getUniqueSessionId();
				
				if(SUCCESS.equals(result.get("result"))) {
					pos.set(userId, newSessionId);
					session.setAttribute(SESSION_ID, newSessionId);
					session.setAttribute(USER_ID, userId);
					session.setAttribute(USER_NAME, (String)userMap.get("userName"));
				}
				
				retMap.put("result", result.get("result"));
				retMap.put("resultData", result.get("resultData"));
				retMap.put("errMsg", result.get("errMsg"));
			} else {
				retMap.put("result", this.ERROR);
				retMap.put("errMsg", "현재 로그인 중입니다.");
				
			}
		}
		return retMap;
	}
	@RequestMapping(value = "/user/logout", method = RequestMethod.GET)	
	public  String logout(HttpServletRequest request
										, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String sessionId = (String)session.getAttribute(SESSION_ID);
		String userId = session.getAttribute(USER_ID).toString();
		ValueOperations<String, String> pos = redisTemplate.opsForValue();
		
		if(sessionId != null) {
			session.removeAttribute(SESSION_ID);
		}
		
		if(userId != null) {
			session.removeAttribute(USER_ID);
			session.removeAttribute(USER_NAME);
		}
		
		if(pos.get(userId) != null) {
			redisTemplate.opsForValue().getOperations().delete(String.valueOf(userId));
		}
		
		return "redirect:/board";
	}

	@RequestMapping(value = "/user/updateUser")
	@ResponseBody
	public Map<String, Object> updateUser(@RequestParam Map<String, String> paramMap) throws Exception {
		
		Map<String, Object> result = userService.updateUser(paramMap);
		
		return result;
	}


	@RequestMapping(value = "/user/deleteUser")
	@ResponseBody
	public Map<String, Object> deletUser(HttpServletRequest request
			, HttpServletResponse response, @RequestParam Map<String, String> paramMap) throws Exception {
		
		Map<String, Object> result = userService.deleteUser(paramMap);
		HttpSession session = request.getSession();
		String sessionId = (String)session.getAttribute(SESSION_ID);
		
		String userId = session.getAttribute(USER_ID).toString();
		ValueOperations<String, String> pos = redisTemplate.opsForValue();
		
		if(sessionId != null) {
			session.removeAttribute(SESSION_ID);
		}
		
		if(userId != null) {
			session.removeAttribute(USER_ID);
			session.removeAttribute(USER_NAME);
		}
		
		if(pos.get(userId) != null) {
			redisTemplate.opsForValue().getOperations().delete(String.valueOf(userId));
		}
		return result;
	}
	
	public String getUniqueSessionId() {
		String sessionId = "";
		String uuid = UUID.randomUUID().toString();
		String[] jsessionIdArray = uuid.split("-");
		StringBuilder jsessionIdBuilder = new StringBuilder();
		for (String str : jsessionIdArray) {
			jsessionIdBuilder.append(str);
		}
		sessionId = jsessionIdBuilder.toString();
		return sessionId;
	}

}
