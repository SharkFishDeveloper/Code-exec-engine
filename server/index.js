
import express from "express";
import fs from "fs";
import path from "path";
import { exec } from "child_process";
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
    windowMs: 60 * 1000, // 1 minute
    max: 10, // Limit each IP to 5 requests per windowMs
    message: "Too many requests, please try again later."
});

const app = express();
app.use(express.json());
app.use('/submit-code', limiter);


app.post("/submit-code",async(req,res)=>{

    const {code,language,stdin} = req.body;
    let shellextension = "";
    let engine = "";
    let fileExtension = "";
    let stdinBool = stdin ? true : false;
  

    switch (language.toLowerCase()){
        case "cpp":
        shellextension = "cp.sh cpp"
        engine = `cpp-engine`
        fileExtension = "cpp"
        break;

        case "c":
        shellextension = "cp.sh c"
        engine = `cpp-engine`
        fileExtension = "c"
        break;

        case "python":
        shellextension = stdinBool ?  "py.sh inputtrue" : "py.sh"
        engine = `python-engine`
        fileExtension = "py"
        break;

        case "java":
        shellextension =stdinBool ? "jv.sh inputtrue" : "jv.sh"
        engine = `java-engine`
        fileExtension = "java"
        break;

        case "js":
        shellextension = stdinBool ? "j.sh inputtrue" : "j.sh"
        engine = `js-engine`
        fileExtension = "js"
        break;
    }
    
    let codeFile = language.toLowerCase() ==="java" ? `Main.${fileExtension}` : language === "js"?`index.${fileExtension}`:`main.${fileExtension}`;

    const __dirname = process.cwd();
    const filePath = path.resolve(__dirname, `../${engine}/app/${codeFile}`);

    fs.writeFileSync(filePath,code);
    
    let command = `docker run --rm -v ${filePath}:/usr/src/app/${engine}/app/${codeFile} `;

    if (stdinBool) {
        const inputfilePath = path.resolve(__dirname, `../${engine}/app/input.txt`);
        command += ` -v ${inputfilePath}:/usr/src/app/${engine}/app/input.txt --memory=100m --ulimit cpu=5 catalyst ./${shellextension}`;
        fs.writeFileSync(`../${engine}/app/input.txt`,stdin);
    }
    else if(stdinBool!==""){
        command += ` --ulimit cpu=5 catalyst ./${shellextension}`;
    }
    // console.log(command)
        const startTime = Date.now();
        await exec(command, (error, stdout, stderr) => {
            const endTime = Date.now(); // Record end time
            const executionTime = endTime - startTime; 
            if (error) {
              console.error(`Error: ${stdout, stderr}`);
              return res.json({stdout:"",executionTime,stderr:stdout})
            }
            console.log(`Output: ${stdout}`);
            return res.json({stdout,executionTime,stderr})
        });
})

app.get("/languages",async(req,res)=>{
    res.send({languages:"By defualt 5 languages run : C\n,C++\n,Java\n,Python\n,Javascript"})
})

app.get("/",async(req,res)=>{
    res.send({message:"You are using Catalyst code engine created by S.F.D"})
})

app.listen(2000,()=>console.log("Start"));