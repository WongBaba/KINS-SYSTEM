using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web.Security;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;
using System.IO;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using KINS_SYSTEM.ImportClass;
using System.Web.Script.Services;

namespace KINS_SYSTEM.Pages.OrderManagement
{
    /// <summary>
    /// ImportOrder 的摘要说明
    /// </summary>
    public class ImportOrder : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/html";
            DataTable dt=xsldata(context);
            if (dt == null) {
                return;
            }
            string temp = insertDB(dt);
            context.Response.Write(temp);
        }

        private string insertDB(DataTable dt){
            try
            {
                int errorcount = 0;//记录错误信息条数  
                int insertcount = 0;//记录插入成功条数  

                DbSql sqldb = new DbSql();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    string sqlStr = "insert into K_TaobaoOrder values (";
                    for (int j = 0; j < 45; j++)
                    {
                        sqlStr += "'" + dt.Rows[i][j].ToString().Replace("\'", "''") + "' ,";
                    }
                    sqlStr = sqlStr.Substring(0, sqlStr.Length - 1) + ")";
                    if (sqldb.ExecSql(sqlStr))
                        insertcount++;
                    else errorcount++;
                }
                return "{ error:'',msg:'导入成功" + insertcount + "条数据导入成功！" + errorcount + "条数据部分信息为空没有导入！'}";
            }
            catch (Exception ex)
            {
                return "{ error:'导入失败，插入数据库失败，请重试或联系管理员'}";
            }
        }

        private DataTable xsldata(HttpContext context)
        {
            try{
                string msg = string.Empty;
            string error = string.Empty;
            string result = string.Empty;
            string filePath = string.Empty;
            string fileNewName = string.Empty;
            //这里只能用<input type="file" />才能有效果,因为服务器控件是HttpInputFile类型
            HttpFileCollection files = context.Request.Files;
            if (files.Count > 0)
            {
                //设置文件名
                fileNewName = System.IO.Path.GetFileName(files[0].FileName);
                //保存文件
                files[0].SaveAs(context.Server.MapPath("~/App_Data/" + fileNewName));
            }
            else
            {
                context.Response.Write("{ error:'导入失败，文件上传出错'}");
                return null;
            }
                 //HDR=Yes，这代表第一行是标题，不做为数据使用 ，如果用HDR=NO，则表示第一行不是标题，做为数据来使用。系统默认的是YES  
                string connstr2003 = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + context.Server.MapPath("~/App_Data/" + fileNewName) + ";Extended Properties='Excel 8.0;HDR=Yes;IMEX=1;'";
                string connstr2007 = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + context.Server.MapPath("~/App_Data/" + fileNewName) + ";Extended Properties=\"Excel 12.0;HDR=YES\"";
                OleDbConnection conn;
                if (fileNewName.IndexOf(".xls") != -1)
                {
                    conn = new OleDbConnection(connstr2003);
                }
                else
                {
                    conn = new OleDbConnection(connstr2007);
                }
                conn.Open();
                string sql = "select * from [Sheet1$]";
                OleDbCommand cmd = new OleDbCommand(sql, conn);
                DataTable dt = new DataTable();
                OleDbDataReader sdr = cmd.ExecuteReader();

                dt.Load(sdr);
                sdr.Close();
                conn.Close();
                //删除服务器里上传的文件  
                if (File.Exists(context.Server.MapPath("~/App_Data/" + fileNewName)))
                {
                    File.Delete(context.Server.MapPath("~/App_Data/" + fileNewName));
                }
                return dt;
            }
            catch (Exception e)
            {
                context.Response.Write("{ error:'导入失败，文件读取出错'}");
                return null;
            }
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