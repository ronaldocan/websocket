package rona.websocket.controller;

import java.io.IOException;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.socket.TextMessage;
import rona.websocket.entity.Message;
import rona.websocket.entity.User;
import rona.websocket.websocket.MyWebSocketHandler;

import com.google.gson.GsonBuilder;

@Controller
@RequestMapping("/msg")
public class MsgController {

	@Resource
	MyWebSocketHandler handler;

	Map<Long, User> users = new HashMap<Long, User>();

	// 模拟一些数据
	@ModelAttribute
	public void setReqAndRes() {
		User u1 = new User();
		u1.setId(1L);
		u1.setName("rona一号");
		users.put(u1.getId(), u1);

		User u2 = new User();
		u2.setId(2L);
		u2.setName("rona二号");
		users.put(u2.getId(), u2);
		User u3 = new User();
		u3.setId(3L);
		u3.setName("rona三号");
		users.put(u3.getId(), u3);

	}

	// 用户登录
	@RequestMapping(value = "login", method = RequestMethod.POST)
	public ModelAndView doLogin(User user, HttpServletRequest request) {
		request.getSession().setAttribute("MyId",user.getId());
		request.getSession().setAttribute("uid", user.getId());
		request.getSession().setAttribute("name", users.get(user.getId()).getName());
		return new ModelAndView("redirect:talk");
	}

	// 跳转到交谈聊天页面
	@RequestMapping(value = "talk", method = RequestMethod.GET)
	public ModelAndView talk() {
		ModelAndView modelAndView = new ModelAndView("talk");
		List<Long> uidList = handler.getAllUserIds();
		List<User> userList = new ArrayList<User>();
		for (Long uid : uidList){
			System.out.println("当前在线人员:");
			userList.add(users.get(uid));
			System.out.println(uid);
		}
		modelAndView.getModel().put("userList", userList);
		return modelAndView;
	}

	@RequestMapping(value = "getAllUser", method = RequestMethod.GET)
	@ResponseBody
	public void getAllUser(Model model, HttpServletRequest request) {

		List<Long> uidList = handler.getAllUserIds();
		List<User> userList = new ArrayList<User>();
		Long nowId = (Long) request.getSession().getAttribute("MyId");
		System.out.println("lala");
		for (Long uid : uidList) {
			if (uid.equals(nowId)) {
				request.getSession().setAttribute("uid", nowId);
				request.getSession().setAttribute("name", users.get(nowId).getName());
			}
			System.out.println("当前在线人员:");
			userList.add(users.get(uid));
			System.out.println(uid);
		}

		model.addAttribute("userList", userList);
	}

	// 跳转到发布广播页面
	@RequestMapping(value = "broadcast", method = RequestMethod.GET)
	public ModelAndView broadcast() {
		return new ModelAndView("broadcast");
	}

	// 发布系统广播（群发）
	@ResponseBody
	@RequestMapping(value = "broadcast", method = RequestMethod.POST)
	public void broadcast(String text) throws IOException {
		Message msg = new Message();
		msg.setDate(new Date());
		msg.setFrom(-1L);
		msg.setFromName("系统广播");
		msg.setTo(0L);
		msg.setText(text);
		handler.broadcast(new TextMessage(new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create().toJson(msg)));
	}

}