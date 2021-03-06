
<%--
  Tencent is pleased to support the open source community by making MSEC available.
 
  Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.
 
  Licensed under the GNU General Public License, Version 2.0 (the "License"); 
  you may not use this file except in compliance with the License. You may 
  obtain a copy of the License at
 
      https://opensource.org/licenses/GPL-2.0
 
  Unless required by applicable law or agreed to in writing, software distributed under the 
  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
  either express or implied. See the License for the specific language governing permissions
  and limitations under the License.
--%>


<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2016/1/25
  Time: 14:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<%
    String service = request.getParameter("service");
    String service_parent = request.getParameter("service_parent");
    String plan_id = request.getParameter("plan_id");
%>
<head>
    <title></title>

  <style>
    #title_bar{width:auto;height:auto;   }

    #result_message{width:auto;height:auto; }

  </style>
  <script type="text/javascript">
      var g_service_name = "<%=service%>";
      var g_service_parent = "<%=service_parent%>";
      var g_plan_id = "<%=plan_id%>";





      function onNextBtnClicked()
      {
          var selectedStr = $("#IDL_list").val();
          if (selectedStr == null || selectedStr.length < 1)
          {
              showTips("请选择需要发布的tag.");
              return;
          }
          var selectedJson = JSON.parse(selectedStr);


          var   request={
              "handleClass":"beans.service.ReleaseStepsGO",
              "requestBody": {
                  "second_level_service_name": g_service_name,
                  "first_level_service_name": g_service_parent,
                  "step_number": 3,
                  "plan_id":g_plan_id,
                  "idl_tag":selectedJson.tag_name
              },
          };
          $.post("/JsonRPCServlet",
                  {request_string:JSON.stringify(request)},

                  function(data, status){

                      if (status == "success") {//http通信返回200
                          if (data.status == 0) {//业务处理成功

                              var url="/pages/releaseSteps/step4.jsp?service="+g_service_name+
                                      "&service_parent="+g_service_parent+
                                      "&plan_id="+g_plan_id;
                              console.log("goto:", url);
                              $("#right").load(url);
                          }
                          else if (data.status == 99)
                          {
                              document.location.href = "/pages/users/login.jsp";
                          }
                          else
                          {
                              showTips(data.message);
                              return;
                          }
                      }
                      else
                      {
                          showTips(status);
                          return;
                      }

                  });
      }
      function getServiceDetail()
      {
          //console.log("begin to load detail info...");
          var   request={
              "handleClass":"beans.service.QuerySecondLevelServiceDetail",
              "requestBody": {
                  "service_name": g_service_name,
                  "service_parent": g_service_parent                 },
          };
          $.post("/JsonRPCServlet",
                  {request_string:JSON.stringify(request)},

                  function(data, status){

                      if (status == "success") {//http通信返回200
                          if (data.status == 0) {//业务处理成功

                              $("#first_level_service_name").empty();
                              $("#first_level_service_name").append(g_service_parent);

                              $("#plan_id").empty();
                              $("#plan_id").append(g_plan_id);

                              $("#second_level_service_name").empty();
                              $("#second_level_service_name").append(g_service_name);



////////////////////////////////////////////////////////////////////////////////////////////////////////
                              var str="";
                              $.each(data.idltagList, function (i, rec) {

                                  var taginfo = {"tag_name":rec.tag_name, "memo":rec.memo};
                                  str += "<option value ='"+JSON.stringify(taginfo)+"'>"+JSON.stringify(taginfo)+"</option>\r\n";


                              });
                              console.log("append to IDL_list:", str);
                              $("#IDL_list").empty();
                              $(str).appendTo("#IDL_list");
////////////////////////////////////////////////////////////////////////////////////////////////////////



                          }
                          else if (data.status == 99)
                          {
                              document.location.href = "/pages/users/login.jsp";
                          }
                          else
                          {
                             showTips(data.message);
                              return;
                          }
                      }
                      else
                      {
                         showTips(status);
                          return;
                      }

                  });

      };

      $(document).ready(function(){

        getServiceDetail();// ajax这些函数的回调可能晚于下面的代码哈

    });

  </script>
</head>
<body>



<div id="title_bar" class="title_bar_style">

    <label for="second_level_service_name">【发布&nbsp;step3】&nbsp&nbsp服务名:</label>
    <label id="second_level_service_name"></label>
    ,&nbsp;

    <label for="first_level_service_name"  >上一级服务名:</label>
    <label id="first_level_service_name"  ></label>
    ,&nbsp;

    <label for="plan_id"  >plan ID:</label>
    <label id="plan_id"  ></label>

</div>
<!--------------------------------------------------------------------------------->




<!--------------------------------------------------------------------------------->

    <div class="form_style">

    <div  class="form_style" id="div_IDL" style="margin-left: 10px;margin-right: 10px;">

        <div>
            <label for="IDL_list"  >选择接口定义文件版本:</label>
            <select id="IDL_list" size="5"  class="form-control"  >
            </select>
            <button type="button" class="btn-small" id="btn_next" onclick="onNextBtnClicked()">下一步</button>
        </div>

    </div>


</div>
<!--------------------------------------------------------------------------------->

<!--------------------------------------------------------------------------------->
        <div id="result_message"  class="result_msg_style">
        </div>

</div>


</body>
</html>
