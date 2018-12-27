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
    /// EditStaff1 的摘要说明
    /// </summary>
    public class EditStaff1 : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            context.Response.Write(onJob(data));
        }
        private string onJob(Data data)
        {
            string sqlStr = " update K_Employee set Emp_name='" + data.Emp_name + "',Emp_deptId='" + data.Emp_deptId + "',Emp_sex='" + data.Emp_sex + "',Emp_birthday='" + data.Emp_birthday + "',Emp_idcard='" + data.Emp_idcard + "',Emp_address='" + data.Emp_address + "',Emp_nowAddress='" + data.Emp_nowAddress + "',Emp_phone='" + data.Emp_phone + "',Emp_positionId='" + data.Emp_positionId + "' where Emp_id='"+data.Emp_id+"'";
            DbSql ds = new DbSql();
            if (ds.ExecSql(sqlStr))
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
            public string Emp_id = "", Emp_name = "", Emp_deptId = "", Emp_sex = "", Emp_birthday = "", Emp_idcard = "", Emp_address = "", Emp_nowAddress = "", Emp_phone = "", Emp_positionId = "";
        }
    }
}