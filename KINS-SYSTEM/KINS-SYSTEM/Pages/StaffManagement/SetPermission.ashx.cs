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
    /// SetPermission 的摘要说明
    /// </summary>
    public class SetPermission : IHttpHandler, System.Web.SessionState.IRequiresSessionState 
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.yhm = context.Session["yhm"].ToString();
            context.Response.Write(setPermission(data,context));
        }
        private string setPermission(Data data, HttpContext context)
        {
            string sqlStr = " update K_Employee set Emp_permissions='" + data.permissions + "' where Emp_id='" + data.id + "'";
            DbSql ds = new DbSql();
            if (ds.ExecSql(sqlStr)){
                reloadPermission(context);
                return "2";//成功
            }
            return "0";//失败
        }

        private void reloadPermission(HttpContext context)
        {
            string sqlStr = "select * from K_Employee where Emp_id='" + context.Session["yhm"].ToString() + "'";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            if (da.Rows.Count > 0)
            {
                context.Session["permissions"] = da.Rows[0]["Emp_permissions"].ToString();
            }
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
            public string id = "", permissions = "",yhm="";
        }
    }
}