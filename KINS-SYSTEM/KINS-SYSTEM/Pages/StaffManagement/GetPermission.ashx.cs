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
    /// GetPermission 的摘要说明
    /// </summary>
    public class GetPermission : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            String data = jss.Deserialize<String>(context.Request["data"].ToString());
            context.Response.Write(getPermission(data));
        }
        private string getPermission(string data)
        {
            string sqlStr = " select Emp_permissions from K_Employee where Emp_id='"+data+"'";
            DbSql ds = new DbSql();
            DataTable da = ds.FillDt(sqlStr);
            if (da.Rows.Count<1)
                return "0";//失败
            return da.Rows[0][0].ToString();//成功
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}