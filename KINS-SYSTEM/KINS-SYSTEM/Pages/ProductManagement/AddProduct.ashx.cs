using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KINS_SYSTEM.ImportClass;
using System.Data;
using System.Web.SessionState;
using System.Runtime.Serialization;
using System.Web.Script.Serialization;

namespace KINS_SYSTEM.Pages.ProductManagement
{
    /// <summary>
    /// AddProduct1 的摘要说明
    /// </summary>
    public class AddProduct1 : IHttpHandler, System.Web.SessionState.IRequiresSessionState 
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.company = context.Session["company"].ToString();
            context.Response.Write(addComponent(data));
        }

        private int addComponent(Data data)
        {
            //返回1代表该零件已存在，返回2代表添加成功，返回0代表数据库添加失败
            string sqlStr = "SELECT * FROM K_Product WHERE Pd_company='"+data.company+"' Pd_id='" + data.Pd_id + "'";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            if (da.Rows.Count > 0)
                return 1;

            sqlStr = "INSERT INTO K_Product (Pd_typeId, Pd_manufacturerId, Pd_parameter, Pd_name, Pd_id, Pd_remarks,Pd_company) VALUES ('" +
                data.Pd_typeId + "', '" + data.Pd_manufacturerId + "', '" + data.Pd_parameter + "', '" + data.Pd_name + "', '" + data.Pd_id + "', '" + data.Pd_remarks + "', '" + data.company + "')";
            if (!ds.ExecSql(sqlStr))
                return 0;
            return 2;
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
            public string Pd_typeId, Pd_manufacturerId, Pd_parameter, Pd_name, Pd_id, Pd_remarks,company="";
        }
    }
}