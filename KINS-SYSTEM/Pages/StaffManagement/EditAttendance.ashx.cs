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
    /// EditAttendance1 的摘要说明
    /// </summary>
    public class EditAttendance1 : IHttpHandler
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
            string sqlStr = " update K_onoffDutyData set  "+getSqlStr(data)+" where O_checkDate='" + data.O_checkDate + "' and O_employeeId='"+data.Emp_id+"'";
            DbSql ds = new DbSql();
            if (ds.ExecSql(sqlStr))
                return "2";//成功
            return "0";//失败
        }

        private string getSqlStr(Data data) {
            string sqlStr = "";
            if (data.O_onDuty1 != "")
                sqlStr += ",O_onDuty1='" + data.O_checkDate + " " + data.O_onDuty1 + "'";
            else
                sqlStr += ",O_onDuty1=NULL";
            if (data.O_onDuty2 != "")
                sqlStr += ",O_onDuty2='" + data.O_checkDate + " " + data.O_onDuty2 + "'";
            else
                sqlStr += ",O_onDuty2=NULL";
            if (data.O_onDuty3 != "")
                sqlStr += ",O_onDuty3='" + data.O_checkDate + " " + data.O_onDuty3 + "'";
            else
                sqlStr += ",O_onDuty3=NULL";
            if (data.O_offDuty1 != "")
                sqlStr += ",O_offDuty1='" + data.O_checkDate + " " + data.O_offDuty1 + "'";
            else
                sqlStr += ",O_offDuty1=NULL";
            if (data.O_offDuty2 != "")
                sqlStr += ",O_offDuty2='" + data.O_checkDate + " " + data.O_offDuty2 + "'";
            else
                sqlStr += ",O_offDuty2=NULL";
            if (data.O_offDuty3 != "")
                sqlStr += ",O_offDuty3='" + data.O_checkDate + " " + data.O_offDuty3 + "'";
            else
                sqlStr += ",O_offDuty3=NULL";
            if (sqlStr.Length > 1)
                sqlStr = sqlStr.Substring(1);
            return sqlStr;
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
            public string Emp_id = "", Emp_name = "", O_onDuty1 = "", O_checkDate = "", O_onDuty2 = "", O_onDuty3 = "", O_offDuty1 = "", O_offDuty2 = "", O_offDuty3 = "";
        }
    }
}