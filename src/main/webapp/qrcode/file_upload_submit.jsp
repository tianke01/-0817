<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				java.sql.*,
				java.io.File,
				org.apache.commons.fileupload.*"%>
<%@ page import="org.springframework.web.multipart.MultipartFile" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%

    DiskFileUpload upload = new DiskFileUpload();

    String tempPath			= "";
    String FolderName		= "";
    String  Path			= "";
    int SiteId				=0;
    String alertMessage		= "";
    String ReWrite			= "";
    String Username			= "";
    String Password			= "";
    boolean isCan			=false;
    tempPath = request.getRealPath("/temp");
    upload.setSizeThreshold(16000);
    upload.setSizeMax(-1);
    upload.setRepositoryPath(tempPath);
    upload.setHeaderEncoding("utf-8");
    java.util.List items = null;
//try{
    items = upload.parseRequest(request);
//}catch(Exception e){System.out.println(e.getMessage());}
    java.util.Iterator iter = items.iterator();
    while (iter.hasNext()) {
        FileItem item = (FileItem) iter.next();
        if (item.isFormField()) {
            String FieldName = item.getFieldName();
            if(FieldName.equals("FolderName"))
                FolderName = item.getString("utf-8");
            else if(FieldName.equals("SiteId"))
                SiteId = Integer.parseInt(item.getString());
            else if(FieldName.equals("ReWrite"))
                ReWrite = item.getString();
            else if(FieldName.equals("Username"))
                Username = item.getString();
            else if(FieldName.equals("Password"))
                Password = item.getString();
        }
    }
    tidemedia.cms.user.UserInfo userinfo_session = new tidemedia.cms.user.UserInfo();
    if(session.getAttribute("CMSUserInfo")!=null)
    {
        userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
    }
    if(userinfo_session!=null && userinfo_session.getId()!=0)
    {
        isCan=true;
    }
    if(!isCan)
    {
        TableUtil tu=new TableUtil("user");
        String Sql = "select * from userinfo where Username='" +tu.SQLQuote(Username) + "' and Password='" +tu.SQLQuote(Password) + "'";
        ResultSet Rs = tu.executeQuery(Sql);
        if(Rs.next())
        {
            //userinfo_session.setId(Rs.getInt("id"));
            userinfo_session = CmsCache.getUser(Rs.getInt("id"));
            isCan=true;
        }
        tu.closeRs(Rs);
    }

    if(!(userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()))
    { isCan=false;}

    if(userinfo_session.isSiteAdministrator())
    {
        if(!userinfo_session.getSite().equals(SiteId+""))
        {isCan=false;}
    }

    if(isCan){

//if(!CheckExplorerSite(userinfo_session,SiteId))
//{ response.sendRedirect("../noperm.jsp");return;}

        Site site=CmsCache.getSite(SiteId);
        String SiteFolder=site.getSiteFolder();
        Path = SiteFolder + "/" + FolderName;

        iter = items.iterator();
        while (iter.hasNext()) {
            FileItem item = (FileItem) iter.next();

            if (!item.isFormField()) {
                String FieldName = item.getFieldName();
                String FileName = item.getName();
                String FileExt = "";

                FileName = FileName.substring(FileName.lastIndexOf("\\")+1);
//System.out.println((FileName));
                int index = FileName.lastIndexOf(".");
                if(index!=-1)
                {
                    FileExt = FileName.substring(index+1);
                }

                if(!FileName.equals(""))
                {//System.out.println(Path + "/" +FileName);

                    String exts = CmsCache.getParameterValue("explorer_edit_file_ext");
                    String ext = Util.getFileExt(FileName);
                    if((exts+",").contains(ext+",")) {
                        File uploadedFile = new File(Path + "/" + FileName);

                        if (!ReWrite.equals("Yes") && uploadedFile.exists()) {
                            alertMessage += FileName + " 已经存在，没有覆盖!";
                        } else {
                            item.write(uploadedFile);

                            //new Log().FileLog("上传文件","/" + FolderName + "/" + FileName,userinfo_session.getId(),SiteId);
                            new Log().FileLog(LogAction.file_add, "/" + FolderName + "/" + FileName, userinfo_session.getId(), SiteId);
                            //发布
                            FileUtil fileutil = new FileUtil();
                            fileutil.PublishFile("/" + FolderName + "/" + FileName, SiteFolder, userinfo_session.getId(), site);
                        }
                    }
                    else
                    {
                        alertMessage += FileName	+ " 文件类型不符合要求!";
                    }
                }
            }
        }
    }
//System.out.println("alertMessage:"+alertMessage);
    if(alertMessage.length()>0){out.println(alertMessage);}%>
