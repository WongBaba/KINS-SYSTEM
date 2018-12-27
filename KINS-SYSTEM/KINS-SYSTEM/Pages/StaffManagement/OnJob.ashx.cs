using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using KINS_SYSTEM.ImportClass;
using System.Data;
using System.Runtime.Serialization;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace KINS_SYSTEM.Pages.StaffManagement
{
    /// <summary>
    /// OnJob1 的摘要说明
    /// </summary>
    public class OnJob1 : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.Emp_company = context.Session["company"].ToString();
            context.Response.Write(onJob(data));
        }
        private string onJob(Data data)
        {
            string sqlStr = " insert into K_Employee (Emp_account,Emp_name,Emp_password,Emp_deptId,Emp_sex,Emp_birthday,Emp_idcard,Emp_address,Emp_nowAddress,Emp_phone,Emp_positionId,Emp_company) values ('" + data.Emp_account + "','" + data.Emp_name + "','123456','" + data.Emp_deptId + "','" + data.Emp_sex + "','" + data.Emp_birthday + "','" + data.Emp_idcard + "','" + data.Emp_address + "','" + data.Emp_nowAddress + "','" + data.Emp_phone + "','" + data.Emp_positionId + "','" + data.Emp_company + "')";
            DbSql ds = new DbSql();
            if(ds.ExecSql(sqlStr))
                return "2";//成功
            return "0";//失败
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        public class Data
        {
            public string Emp_account = "", Emp_name = "", Emp_deptId = "", Emp_sex = "", Emp_birthday = "", Emp_idcard = "", Emp_address = "", Emp_nowAddress = "", Emp_phone = "", Emp_positionId = "", Emp_company = "";
        }
    }
}