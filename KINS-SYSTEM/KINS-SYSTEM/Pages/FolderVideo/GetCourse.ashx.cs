using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.SessionState;
using System.Runtime.Serialization;
using System.Web.Script.Serialization;
using System.IO;
using System.Net;

namespace TaoBaoVideo.Pages
{
    /// <summary>
    /// Download 的摘要说明
    /// </summary>
    public class GetCourse : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            string[] folders = Directory.GetDirectories(data.path);
            string[] files = Directory.GetFiles(data.path);
            string course = files[0];
            for (int i = 1; i < files.Length; i++)
                course += "|" + files[i];
            context.Response.Write(course);

        }

        /// 创建文件夹
        /// </summary>
        /// <param name="Path"></param>
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        public class Data
        {
            public string path;
        }
    }


}