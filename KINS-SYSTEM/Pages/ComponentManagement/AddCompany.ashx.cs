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
    /// AddCompany1 的摘要说明
    /// </summary>
    public class AddCompany1 : IHttpHandler, System.Web.SessionState.IRequiresSessionState 
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain"; 
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.company = context.Session["company"].ToString();
            context.Response.Write(addCompany(data));
        }

        private int addCompany(Data data)
        {
            //返回1代表该公司已存在，返回2代表添加成功，返回0代表数据库添加失败
            string sqlStr = "SELECT * FROM K_info_Company WHERE Co_company='"+data.company+"' and Co_abbreviation='" + data.abbreviation + "'";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            if (da.Rows.Count > 0)
                return 1;
            sqlStr = "INSERT INTO K_info_Company (Co_abbreviation, Co_name, Co_phone, Co_email, Co_address, Co_englishName,Co_company) VALUES ('" +
                data.abbreviation + "', '" + data.name + "', '" + data.phone + "', '" + data.email + "', '" + data.address + "','" + data.en_name + "','" + data.company + "')";
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
    }
    public class Data
    {
        public string en_name, name, email, address, phone, abbreviation,company="";
    }
}