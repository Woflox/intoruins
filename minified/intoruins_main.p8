pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--iNTO rUINS cART 2
--
--unminned:github.com/woflox/intoruins
function modeis(n)return mode==n end function getbtn(n)n&=btns btns&=~n return n~=0end function _update()btns|=btnp()if modeis"play"and not waitforanim then updateturn()elseif modeis"aim"then updateaim(unpack(aimparams))elseif modeis"reset"and statet>.3then load"intoruins"end statet+=.03333if mode~="ui"then waitforanim=#rangedatks>0for n,_ENV in inext,ents do update()end end smoothb=lerp(smoothb,screenpos(lerp(player.pos,vec2s"10,9.5",(modeis"gameover"or modeis"victory")and max(.36-statet*2)or.36)),.5)smooth=lerp(smooth,smoothb,.25)function getcampos(n)return flr(rnd(player.shake*2)-player.shake+n-63.5)end campos=vec2(getcampos(smooth.x),getcampos(smooth.y))player.shake*=shakedamp end function _draw()cls()camera(campos.x,campos.y)lfillp,anyfire=localfillp(49110.25,-campos)for e,n in inext,drawcalls do n[1](unpack(n[2]))end if anyfire~=fireplaying then fireplaying=anyfire call(anyfire and"music(32,500,3"or"music(-1,500")end foreach(rangedatks,function(n)n[2][1]+=1if n[1](unpack(n[2]))then del(rangedatks,n)end end)call"pal()palt(1)pal(15,129,1)pal(11,131,1)fillp("if modeis"play"or modeis"victory"then for e,n in inext,ents do local _ENV=n.textanim if _ENV and t<=.5then t+=speed pos.y-=.5-t?text,mid(campos.x,4+pos.x-#text*2,campos.x+128-#text*4)-wavy*cos(t*2),pos.y+offset,t>.433and 5or col
else n.textanim=nil end end elseif modeis"aim"then?"ᶜ7⁵fd⁙",aimscrposx,aimscrposy
end camera()if modeis"play"or modeis"ui"then barx=-2drawbar("HP",player.hp,player.maxhp,2,8)for e,n in pairs(player.statuses)do drawbar(unpack(n))end elseif modeis"aim"then call"print(ᶜ6⬅️⁵fd⬆️⁵8m⬇️⁵fd➡️:aIM      ❎:fIRE,18,117"end if modeis"ui"then if(getbtn"16")popdiag()
uitrans*=.33for n,e in inext,diags do focus,curindex=n==#diags,0e()end end call("textcrawl(³fgAME oVER                                        \n\n\n\n\n\n\n\n\n⁵jcdEPTH:"..depth.."            \n\n³a❎:tRY AGAIN,47,28,1.3,13,gameover,16)textcrawl(  ⁶x5◆ victory ◆⁶x4                                                                                                                                                                                                \n\n\nyOU ESCAPED WITH THE\n³owINGS OF yENDOR!                                        \n\n³h⁴isTEPS TAKEN:³x"..stepstaken.."               \n³hiTEMS F³fOUND:³y"..itemsfound.."             \n³hcREATURES SLAIN: "..creaturesslain.."                \n\n\n\n     ³i❎:cONTINUE,24,21,6,7,victory,8")end function popdiag()deli(diags)uitrans=1if#diags==0then uimode=setmode"play"end end function drawbar(t,e,i,d,o)camera(barx,0)local n=max(print("²0"..t,0,117,0),20)local e=ceil(e*n/i)-1rect(-1,122,n,126,15)rect(0,123,e,125,o)if e>0then rectfill(0,124,e-1,125,d)end?t,0,116,d
barx-=n+4camera()end function textcrawl(e,t,d,n,i,o,f)if mode==o and statet>n then if not musicplayed then music(f)musicplayed=true end?sub(e,0,statet*30+tonum(statet>7.25)*40),t,d,statet>n+.1and i or 1
if btnp"5"then fadetoblack=true call"music(-1,300)setmode(reset"end end end function log(n)player.animtext(n..",col:7,speed:0.01666")end function frame(n,e,t,d,i)clip()i(n-1,e-1,t+1,d+1,0)rect(n,e,t,d,1)cursor(n+5,e+3)clip(0,0,t-.4,d)end function listitem(t,n,e)if n==nil then curindex+=1n=curindex==menuindex end?(n and"²0³8❎ ³g"or"")..t,e and 5or n and 7or 13
return n and focus and getbtn"32"and not e end function getindex(n,e)return focus and(e+tonum(getbtn"8")-tonum(getbtn"4")+n-1)%n+1or e end function gettrans(n)local n,e=usplit(n)return lerp(e,n,focus and uitrans or.56*(1-uitrans))end function listitems(n,e)foreach(inventory,function(n)if n.equipped==e then invi+=1if listitem(n.getname(),invi==invindex,uimode=="iDENTIFY"and n.isid()or uimode=="eMPOWER"and n.orb)then dialog(info)selitem=n end end end)end function inv()frame(gettrans"126,40",6,126,111,rect)?uimode and"ᶜc"..uimode.." AN iTEM\nᶜ1³c……………… EQUIPPED"or"ᶜdiNVENTORY\nᶜ1³c……………… EQUIPPED"
invi,invindex=0,getindex(#inventory,invindex)call"listitems(t,t)print(\n³c………………★ ³dSTOWED,1)listitems("end function info()menuindex=getindex(uimode and 1or 2,menuindex)local _ENV,e=selitem,gettrans"42,4"frame(e,6,gettrans"42,93.5",111,rectfill)spr(typ+profilepic,e+3,8)?"ᶜd  ³h"..getname()
local n="ᶜ1³c……………………………ᶜd"if isid()then foreach(split("\nnAME: ,name|\nwHEN DESCENDING\nSTAFFS CHARGE +,recharge|\ncASTS 」GHT\ntHROW TO START FIRE⁵gk\nsTOWING DOUSES FLAME,lit|\n,desc1|\n,desc2|\n,desc3|\n,desc4|\naTTACK SHAPE:   ⁴h●⁵2i●³k●⁵2h♥⁵0k,arc|\ndARKSIGHT:³s+,darksight|\nhEAL⁵fgTH:   ³z,hp|/,maxhp|\nfREEZE TURNS:³l,freezeturns|\nkNOCKBACK:³v1,knockback|\nsTUN:      ³x,stun|\naCCURACY:³v+,atk|\ndAMAGE:  ³z,dmg|\nrANGE:    ³y,range|\naRMOR:  ³z+,armor|\ntHROW RANGE:  ,throw|\ntHROW ACC:³q+,throwatk|\ntHROW DAMAGE:,throwdmg|\n⁵gkcHARGES: ,charges|/,maxcharges|\n⁵gkᶜecURSED: cANNOT BE\nREMOVED; dESTROYED\nBY EMPOWERMENT,cursed","|"),function(e)k,v=usplit(e)local e,t=selitem[v],eMPOWER(v,true)if e then n..=k..e if uimode=="eMPOWER"and t then n..="ᶜc▶"..t.."ᶜd"end end end)else n..="\n  ????"end?n
?"ᶜ1³c……………………………",e+5,86
foreach(uimode and{uimode}or{slot and(equipped and(lit and"eXTINGUISH"or"sTOW")or"eQUIP")or"uSE","tHROW"},function(n)if listitem(n,nil,cursed and equipped and not _g.uimode or n=="uSE"and charges==0or n=="eQUIP"and player[slot]and player[slot].cursed)then call"popdiag()popdiag()sfx(25"player.skipturn=true selitem[n]()end end)end function confirmjump()frame(33,gettrans"32,37.5",95,gettrans"33,82.5",rect)menuindex=getindex(2,menuindex)?"ᶜd⁴itHE HOLE OPENS\nUP BELOW YOU...\n³d⁴hᶜ1……………………"
if listitem" jUMP DOWN"then popdiag()player.move(playerdst)elseif listitem" dON'T JUMP"then popdiag()end end function dialog(n,e)uitrans,menuindex=mode=="ui"and.33or 1,1setmode"ui"add(diags,n)return e or sfx"39"end function setmode(n)at("statet:0,btns:0,mode:"..n,_ENV)end function tile(e,n)local _ENV=objtable"fow:1,fire:0,spores:0,newspores:0,hilight:0,hifade:0,light:-10,lflash:-10,lflashl:-10,death:41,adjtl:{}"typ,pos,tlscrpos=e,n,screenpos(n)set=function(n)typ,bg,genned=n end draw=function(t,d,n,i,e,o,f,l)dtyp=t or f and bg or typ if frozen then if fget(dtyp+1,5)then dtyp,o=56else pal(frozepal)end end local t,a=fget(dtyp,2)and 5or 0,dtyp+192for n=0,6do if not f and fow==4and fget(a,n)then local n=d.adjtl[n]if n and n.lightsrc then dtyp=a pal(8,n.lcool and 13or 4)pal(9,n.lcool and 12or 9)end end end sspr(dtyp%16*8+i.x,dtyp\16*8+i.y-t,e.x,e.y+t,n.x,n.y-t,e.x,e.y+t,o)if l then local _ENV=d hifade+=mid(-1,hilight-hifade,1)if hifade>0then call"pal(2,34,2"spr(hifade*16-8,n.x,n.y,2,1)end hilight=0end end drawents=function()checkeffects()for e,n in inext,tlentvars do if(_ENV[n])_ENV[n].draw()
end end initpal=function(e)pal()palt(1)local n=1if e then if not fadetoblack then if modeis"gameover"then n=_ENV==player.tl and 3or 1elseif vistoplayer and mode~="ui"and(mode~="victory"or statet<6)then n=light>=2and 4or 3elseif explored then n=2end end fow+=mid(-1,n-fow,1)end if fow<4then fillp(lfillp)pal(fowpals[fow],2)else fillp()end end checkeffects=function()function checkeffect(e,n)if effect then local _ENV=effect if typ==e then if alive and not n then setanim(deathanim)alive,light=nil end elseif n then destroy(_ENV)end end if not effect and n then create(e,pos)end end local n=fire>0or ent and ent.statuses.BURN _g.anyfire=_g.anyfire or n and mode~="ui"and mode~="victory"checkeffect(138,n)checkeffect(139,spores>0and not n)end tileflag=function(n)return fget(typ+n\8,n%8)end navigable=function(n)return tileflag(n and 8or 0)end flatten=function()if typ==tlonggrass then typ=tflatgrass end end setfire=function(n)fire,frozen=max(fire,1)if n then spores,newspores=0,0end entfire()end sporeburst=function(n)spores+=n sfx"17"end entfire=function()if ent and not ent.nofire then ent.burn()end end freeze=function(n)frozen,fire=true,0flatten()local _ENV=ent if _ENV then if hitfire then setanim"brazierdeath"end statuses.BURN=setstatus("FROZEN,"..n..","..n..",13,6")animtext"○"_g.aggro(tl)end end visitadjrnd=function(e)local n={unpack(adjtl)}while(#n>0)e(del(n,rnd(n)),.5)
end return _ENV end function setupdrawcalls()alltiles(function(_ENV)local e=nil function tdraw(t,i,n,f)if not e then add(drawcalls,{initpal,{true}})e=true end local e,d=n and(bg and t.bg or t.typ),flip if not n and t.tileflag"14"then e=tdunjfloor end local o,a,l=unpack(specialtiles[n and e or"default"])local a=a[n or 1]if n then if e==tywall and not i.altwall then o+=vec2s"-6,-2"elseif e==thole then e+=192if n>3then e+=2d=false o+=vec2s"0,1"end end d=d and n%3==2end add(drawcalls,{draw,{e,i,i.tlscrpos+a+o,a,l[n or 1],d and t.tileflag"6",f,not(n or f)}})end local e,n=fget(typ,3),adjtl[3]if bg then tdraw(_ENV,_ENV,nil,true)end if not e and tileflag"5"or tileflag"14"and altwall then tdraw(_ENV,_ENV)end for t,n in inext,split"2,1,3,4,5,6"do if e and n==4then tdraw(_ENV,_ENV)end local e=adjtl[n]if e then local t=e.typ if typ~=tcavewall and typ~=tempty and t==tcavewall then tdraw(e,_ENV,n)elseif n<=2and e.tileflag"11"then walltl=adjtl[n]if t==tywall and n==1and not walltl.altwall then tdraw(e,walltl)end tdraw(e,walltl,n)end if(tileflag"15"or bg==thole)and n<=3and t~=thole and e.bg~=thole then tdraw(_ENV,_ENV,n+(e.manmade and 3or 0),bg==thole)end end end if n and n.tileflag"8"then add(drawcalls,{n.drawents,{}})end end)end function gettile(n)local e=world[n.y]return e and e[n.x]end function inbounds(n)local e=tileinbounds[n.y]return e and e[n.x]end function rndtl()return rnd(inboundtls)end function alltiles(n)foreach(validtiles,n)end function dijkstra(n,e,i)while#e>0do local t=deli(e,1)local d=t[n]-1for t,_ENV in inext,t.adjtl do if _ENV[n]<d then _ENV[n]=d if fget(typ,i)then add(e,_ENV)end end end end end function calcdist(e,n,t)n=n or player.tl alltiles(function(n)n[e]=t or-1000end)n[e]=0dijkstra(e,{n},0)end function viscone(n,a,l,d,i,o)n+=a local f,r=false for e=ceil(d),flr(i)do local _ENV=gettile(n+e*l)if _ENV then local c,t=tileflag"1"vis=tileflag"5"or tileflag"14"and player.pos.x<n.x if c then if r and not f then d=e-.5end if e==flr(i)then t=i end elseif f then t=e-.5end if t then local e=(o+1)/o viscone(n,a,l,e*d,e*t,o+1)end f,r=c,true end end end function calcvis()alltiles(function(_ENV)vis=ent==player end)for n,e in inext,adj do viscone(player.pos,e,adj[(n+1)%6+1],usplit"0,1,1")end end function calclight(n,e,t,d)local n={}alltiles(function(_ENV)light=lflash if t then lflash,lflashl=-10,-10else light=max(light,lflashl)end lcool=light>2for e,n in inext,tlentvars do local n=_ENV[n]if n then local e=n.stat"light"if e and e>light then light,lcool=e,lcool or n.lcool end end end lightsrc=light>2if light>0then add(n,_ENV)end end)dijkstra("light",n,1)if e then repeat local n=true for _ENV in all(ents)do if hp and stat"burnlight"and tl.light>=2and not statuses.BURN then if d and nolightspawn then destroy(_ENV)else burn()trysetfire(tl)tl.light,n=4dijkstra("light",{tl},1)sfx"36"end end end until n end alltiles(function(_ENV)local n=player.stat"darksight"vistoplayer=vis and(light>-n or pdist>-2-n)explored=explored or vistoplayer end)end function trysetfire(_ENV,n)frozen=nil if tileflag"10"or spores>0or rndp(n or 1)and(tileflag"9"or ent and ent.flammable)then setfire"true"end end function updateenv()alltiles(function(_ENV)if spores>0then spores=max(spores-rnd"0.25")if spores>1then local n={}visitadjrnd(function(_ENV)if tileflag"8"and fire==0then add(n,_ENV)end end)local e=spores/(#n+1)newspores-=spores-e for n,_ENV in inext,n do newspores+=e end end end end)alltiles(function(_ENV)if fire>=2then entfire()visitadjrnd(trysetfire)if tileflag"9"then if rndp"0.2"then fire,typ=0,34end elseif spores==0then fire=0if tileflag"10"then typ=thole checkfall(ent)checkfall(item)end end end end)alltiles(function(_ENV)spores+=newspores newspores=0if fire>=1then fire+=1setfire"true"end checkeffects()end)end function findfree(e,d,n)calcdist("free",e,n)local n,e=n or-1000alltiles(function(_ENV)local t=free-rnd()if navigable()and not _ENV[d]and t>n then n,e=t,pos end end)return e end function screenpos(n)return vec2(n.x*12,n.y*8+n.x*4)end function usplit(...)return unpack(split(...))end function round(n)local e=flr(n+.5)return e,n-e end function hexdist(n,e)local t=n+-e return(abs(t.x)+abs(t.y)+abs(n.x+n.y-e.x-e.y))/2end function hexline(t,d,o,i,f)local e,n={},hexdist(t,d)for o=1,min(f and 20or n,o)do local n=gettile(hexnearest(lerp(t,d,o/n)))if not n or not n.tileflag"8"or n.ent and i=="block"then break end add(e,n)if n.ent and i~="pass"then break end end return e,#e>=n end function hexnearest(e)local t,n=round(e.x)local d,e=round(e.y)return abs(n)>abs(e)and vec2(t+round(n+e/2),d)or vec2(t,d+round(e+n/2))end function hexdir(n,e)local n=hexnearest(lerp(n,e,1/hexdist(n,e)))+-n for e,t in inext,adj do if(t==n)return n,e
end end function vec2s(n)return vec2(usplit(n))end function vec2list(e)local n={}for t,e in inext,split(e,"|")do add(n,vec2s(e))end return n end function at(e,n,t,d)n=n or{}for t,e in inext,split(e,t)do local t,e=usplit(e,d or":")n[t]=e=="{}"and{}or e end return n end function objtable(n)return setmetatable(at(n),{__index=_ENV})end function call(n)for e,n in inext,split(n,")")do local n,e=unpack(split(n,"(",false))_ENV[n](usplit(e))end end function rndint(n)return flr(rnd(n))end function rndp(n)return rnd()<tonum(n)end function lerp(n,e,t)return n and(1-t)*n+t*e or e end vec2mt={__add=function(n,e)return vec2(n.x+e.x,n.y+e.y)end,__unm=function(n)return vec2(-n.x,-n.y)end,__mul=function(n,e)return vec2(n*e.x,n*e.y)end,__eq=function(_ENV,n)return x==n.x and y==n.y end}vec2mt.__index=vec2mt function vec2(n,e)return setmetatable({x=n,y=e},vec2mt)end function localfillp(e,_ENV)local n,t=flr(e),x&3local t,d=15\2^t*4369,n+(n>>>16)>><(y&3)*4+t return e-n+flr((d&t)+band(d<<>4,-1-t))end function create(e,t,d,i)local _ENV=objtable"var:ent,xface:1,yface:-1,animframe:0,animt:1,animspeed:0.5,animheight:1,animflip:1,deathanim:death,atkanim:eatk,fallanim:fall,death:41,wpnfrms:0,throwflp:1,movratio:0.25,diri:2,pdist:0,lvl:0,scrxoffset:-2.5,width:1,pushanim:push,profilepic:0,idprefix:³g☉ ,yoffs:2,yfacespr:0,countid:generic,alive:true,statuses:{}"behav,typ,group=d,e,i at(entdata[e],_ENV)counts[countid]+=1animoffset,name,maxhp=vec2(0,yoffs),ai and rnd(split"jEFFR,jENN,fLUFF,gLARB,gREEB,pLORT,rUST,mELL,gRIMB")..rnd(split"Y⁵gk,O⁵gk,US⁵gk,OX⁵gk,ERBEE⁵gk,E」A⁵gk"),hp draw=function()if tl.vistoplayer or lasttl and lasttl.vistoplayer then tl.initpal()if isplayer then pal(8,stat"ccol")pal(9,stat"acol")end if flash then flash=pal(split"7,7,7,7,7,7,7,7,7,7,7,7,7,7")elseif animpal then pal(animpal)fillp(lfillp)elseif statuses.FROZEN then pal(frozepal)end local d=xface*animflip<0local n,e=renderpos+vec2(d and-1or 0,0),animframe+max(yface*yfacespr)spr(animtele and 153or typ+e*16,n.x,n.y,width,animheight,d)local t=aimitem or wpn if t and e<=5then local i=vec2list"3,-2|2,-1|1,-2|1,3|3,-3|1,0"[e+1]if t.victory then i=vec2s"-1,1"call"palt(14,t"end call"pal(8,8)pal(9,9"spr(t.typ+e%4*t.wpnfrms,n.x+i.x*xface,n.y+i.y,1,animheight,d)end lasttl=nil end end setanim=function(n)anim,animt,animloop=split(entdata[n],""),1,false end checkidle=function()if idleanim then setanim(idleanim)else animframe,animheight,anim,animclip=0,1end end setbehav=function(n)if behav~=n then if behavis"sleep"and animloop then checkidle()end behav,canact=n if not statuses.FROZEN then if behavis"hunt"then animtext"!"sfx(alert)elseif behavis"search"then animtext"?"end end end end behavis=function(n)return behav==n end setpos=function(n,e)if tl and tl[var]==_ENV then tl[var],tl=nil end if n then tl,pos=gettile(n),n tl[var]=_ENV if e then renderpos=entscreenpos()+animoffset end checkfall(_ENV)if not flying then tl.flatten()end if statuses.BURN then trysetfire(tl)end if n==playerdst and player.waited and player.stat"guard"and hp then player.interact(_ENV)end end end stat=function(e)local n=0for d,t in inext,itemslots do if _ENV[t]then local e=_ENV[t][e]if e then n=type(e)=="number"and n+e or e end end end return n~=0and n or _ENV[e]end setstatus=function(n)statuses[split(n)[1]]=split(n)end heal=function(n)hp=min(hp+n,maxhp)end tickstatuses=function()if actor and tl.spores>0then heal(2)if tl.vistoplayer and(not textanim or textanim.lowprio)then animtext"+,lowprio:"end if isplayer then call"sfx(17,-1,6"end end for n,e in next,statuses do if n=="BURN"then hurt(1,nil,true)end e[2]-=1if e[2]<=0then statuses[n]=nil if n=="TORCH"then wpn.eXTINGUISH()elseif n=="」GHT"then light,lcool=nil end end end if isflesh and rndp"0.25"then alive=setanim"fleshdeath"end end animfuncs={function()animoffset=movratio*screenpos(dir)end,function()animpal=split"8,8,8,8,8,8,8,8,8,8,8,8,8,8"animtext"•,col:8,speed:0.1,offset:0"end,function()animclip=animoffset.y end,function()doatk(atktl,stat"atkpat")end,function()_g.fadetoblack=true end,function()animflip=-1end,function()if tl.vistoplayer then animtext"Z,wavy:1"end end,function()hurt(hp>maxhp\20and min(maxhp\3,hp-1)or 1000)end,function()flash=true end,function()shake,_g.shakedamp=1,.985call"music(32,20,3"end,function()hurt(2)animoffset=vec2s"0,0"if pushtl.ent then pushtl.ent.hurt(2,pushdir)end if statuses.BURN then pushtl.entfire()end end,function()animloop=animindex+1animt+=rnd(#anim-animloop)end,function()if stat"fallheal"then heal(3)call"sfx(17,-1,6"end local n=stat"recharge"if n then foreach(inventory,function(_ENV)if charges then charges=min(maxcharges,charges+n)end end)call"sfx(55,-1,6,10"end if depth==16then call"sfx(61,-1,1,3"animtext"³i웃 dEPTH 16 ⌂,speed:0.014,col:14"else log("³i◆ dEPTH "..depth.." ◆")end end,function()animflip,animtele=1end,function()destroy(_ENV)end,function()deli(inventory).eQUIP()sfx"25"end,function()call"sfx(2)music(-1,300"end,function()animwait=false end,function()renderpos=nil end,function()animtele=true end,function()animt+=1light,lcool=anim[animindex+1]-4call"calclight(,t,t"end,function()animt+=1animoffset.y+=anim[animindex+1]-4end,function()animwait=true end,function()_g.depth+=1genmap(pos,tl.manmade)end}update=function()function tickanim()animindex=flr(animt)local n=anim[animindex]if type(n)=="string"then animfuncs[ord(n)-96]()animt+=1tickanim()else animframe=n or 0animt+=animspeed if flr(animt)>#anim then if animloop then animt=statuses.FROZEN and animindex or animloop else checkidle()animoffset=vec2s"0,0"end end end end if anim then tickanim()end if animwait then _g.waitforanim=true end if animclip then animheight=1-(animoffset.y-animclip)/8end if pos then renderpos=lerp(renderpos,entscreenpos()+animoffset,.5)end end canmove=function(n,e)local n=gettile(n)if n.ent then return atk and e~="noatk"and not(ai and n.ent.ai)and(n.ent.armor or behavis"hunt"or isplayer)end return e~="atkonly"and n.navigable(flying)end seesplayer=function()return tl.vis and(tl.pdist>=-1or player.tl.light>=2or nightvision)end findmove=function(t,d,i)local o,e=-2tl.visitadjrnd(function(n)if canmove(n.pos,i)and n.fire==0then local t=abs(tl[t]-d)-abs(n[t]-d)if burnlight and tl.light>-1and tl.pdist<-1then t-=3*(n.light-tl.light)end if t>o then o,e=t,n end end end)if e then if i=="aggro"and e.pdist==0then aggro(tl)else return move(e.pos)end end end taketurn=function()function checkseesplayer()if seesplayer()then _g.pseen,_g.lastpseentl=true,player.tl end end if statuses.FROZEN or statuses.STUN or skipturn then skipturn,waited=ai and checkseesplayer()return true end if isplayer then call"turn(1,4)turn(2,6)turn(8,8"function updst()_g.playerdst,aimitem=pos+adj[player.diri]dsttile=gettile(playerdst)end updst()lookat(playerdst)waited,dsttile.hilight=getbtn"16",2if getbtn"32"then dialog(inv)return end if waited then sfx"40"return true end if getbtn"4"then dsttile.hilight=0if canmove(playerdst)then if move(playerdst,true)then pickup(dsttile.item)updst()if stat"lunge"and dsttile.vistoplayer and dsttile.ent and mode~="victory"then interact(dsttile.ent)end end return true elseif dsttile.tileflag"15"then dialog(confirmjump)end end elseif ai and canact and alive then if behavis"hunt"then checkseesplayer()if not(ratks and rndp(rangep)and dorangedatk(usplit(rnd(split(ratks,"|")),";")))then findmove("pdist",rndp"0.5"and altpdist or pdist,movandatk and"noatk")end checkseesplayer()if movandatk then findmove("pdist",0,"atkonly")end else function checkaggro(n)if seesplayer()and rndp(n)then aggro(tl)return true end end if behavis"search"then if not checkaggro"1.0"then findmove("search",pdist,"aggro")if not checkaggro"1.0"and tl.search==pdist then setbehav"wander"end end else checkaggro"0.29"if behavis"wander"then if not wanderdsts[group]or pos==wanderdsts[group]or rndp"0.025"then repeat wandertl=rndtl()wanderdsts[group]=wandertl until wandertl.navigable()and wandertl.pdist>-1000calcdist(group,wandertl)end findmove(group,0,"aggro")checkaggro"0.29"end end end end end dorangedatk=function(n,f,d,a,l,r,i)local o,t,e=0if(n=="ice"and noice)return
function checktl(n)local f,l=hexline(pos,n.pos,usplit(f,"_"))if l then local _ENV,d=n.ent,i and not summoned and 100+n.pdist or d if _ENV and ai and hp<maxhp and n.spores==0then d+=a end if d>o then o,t,e=d,f,n end end end checktl(player.tl)d=l tl.visitadjrnd(checktl)if t then sfx(r)setanim"ratk"lookat(e.pos)if i then summoned=create(75,e.pos)summoned.setanim"bladesummon"elseif healer then e.sporeburst(.9)end return add(rangedatks,{rangedatk,{0,t,n}})end end hurt=function(n,e,t,d)hp-=n flash,shake=true,1if hp<=0then if ai and alive then _g.creaturesslain+=1end sfx(death)alive=setbehav"dead"setanim(deathanim)if isplayer then call"setmode(gameover)print(⁶!5f40゜)calclight("elseif sporedeath then tl.sporeburst(sporedeath)if statuses.BURN then tl.setfire()end elseif summoned and summoned.alive then summoned.hurt(10)end else sfx"34"if hurtsplit and not(statuses.FROZEN or t)then local n=findfree(tl,"ent",-2)if n then hp/=2local n=create(typ,n,behav,group)if statuses.BURN then n.burn()end n.renderpos,n.hp=renderpos,hp n.setanim"esplit"end end end if statuses.FROZEN then sfx"27"statuses.FROZEN[2]-=n elseif hurtfx then sfx(hurtfx)end aggro(tl)if d or hitpush and e then push(e)elseif hitfire then sfx"36"tl.setfire"true"end end push=function(n)if(nopush)return
local e=pos+n pushdir,pushtl,lasttl=n,gettile(e),tl if hitfire then sfx"36"light=(pushtl.navigable()and pushtl or tl).setfire"true"end if(pushtl.navigable(flying)or pushtl.tileflag"15")and not pushtl.ent then setpos(e)if isplayer then call"calcdist(pdist)calcvis()calclight("end else setanim(pushanim)animoffset=.66*screenpos(n)end end burn=function()statuses.FROZEN=setstatus"BURN,6,6,8,9"end doatk=function(e,d)local n=e.ent if atk and n then local t=1if n.armor then local n=(throwatk or stat"atk")-n.stat"armor"t=(max(n)+1)/(abs(n)+2)end local i,o=hexdir(pos,e.pos)if rndp(t)then local t=min(stat"dmg",n.hp)n.hurt(throwdmg or t,i,nil,armor and stat"knockback")if n.armor then if stat"dmgheal"then heal(t)animtext"+,col:8"end if stat"dmghurt"then hurt(t)end if stat"stun"and armor and n.hp>0then n.setstatus(ai and"STUN,2,2,11,3"or"STUN,3")n.animtext"○,wavy:1"end end if makeflesh then e.visitadjrnd(function(_ENV)if navigable()and not ent then create(89,pos)end end)end else aggro(e)end for n in all(split(d,"|"))do doatk(e.adjtl[(o+n)%6+1])end end skipturn=stat"slow"end interact=function(n)setanim(atkanim)sfx"33"atktl=n.tl end move=function(t,d)local n,i=gettile(t),tl lookat(t)local e=n.ent if e and not(makeflesh and e.isflesh)and e.alive then interact(e)else if moveanim then setanim(moveanim)end if d then _g.stepstaken+=1if n.frozen then call"sfx(28,-1,12,3"else sfx(entdata[n.typ])if n.tileflag"7"then aggro(n)end end end setpos(t)if makeflesh then create(89,i.pos)end return true end end lookat=function(n)deltax,dir,diri=n.x-pos.x,hexdir(pos,n)if deltax~=0then xface=sgn(deltax)end yface=dir.y==0and xface or dir.y end tele=function(n)if not n then repeat n=rndtl()until n.navigable()and not n.ent end setanim"tele"if(n.ent)return
setpos(n.pos,true)if isplayer then pickup(n.item)call"calcdist(pdist)calcvis()calclight("end end eQUIP=function()if player[slot]then player[slot].sTOW()end player[slot],equipped=_ENV,"t"id()if cursed then sfx"44"end end sTOW=function(n)if equipped then equipped,player[slot]=nil if lit then eXTINGUISH(n)end end end tHROW=function()aim{_ENV,{throw},"throw"}end function orbis(n)return orb==n end uSE=function()if orb then orbeffect(player.tl,true)destroy(_ENV)else aim{_ENV,{range,linemode,true},rangetyp}end end orbeffect=function(n,t)local e=n.ent or n.item if t then if orbis"light"then player.setstatus"」GHT,160,160,2,13"at("light:4,lcool:",player)calclight()elseif orbis"slofall"then player.setstatus"SLOFALL,160,160,2,3"elseif orbis"eMPOWER"or orbis"iDENTIFY"then _g.uimode=orb dialog(inv,true)elseif orbis"life"then player.maxhp+=3player.hp=player.maxhp log"+MAX HP"end else sfx"27"if orbis"light"then n.lflash=8elseif(orbis"eMPOWER"or orbis"iDENTIFY")and e then e[orb]()elseif orbis"life"then n.sporeburst(12)end end for e=6,0,-1do local n=n.adjtl[e]if orbis"slofall"and n.ent and not t then n.ent.canact=n.ent.push(e>0and adj[e]or player.dir)elseif n.tileflag"8"and n.typ~=thole then if orbis"fire"then n.setfire"true"elseif orbis"ice"then n.freeze(freezeturns)end end end sfx(orbfx)id()if orbis"tele"and e then e.tele()end end eXTINGUISH=function(n)if not n then throwln,typ,lit,light=.125,131end player.statuses.TORCH=nil end eMPOWER=function(e,n)for t,n in inext,enchstats do if _ENV[n]then local t=(n=="charges"and maxcharges or _ENV[n])+1if e then if e==n then return t end else _ENV[n]=t end end end if not n then call"sfx(55,-1,0,16"if(tl and not cursed)animtext"+LVL,speed:0.01666"
end if cursed and not e then sTOW()destroy(_ENV)ided[typ]=true call"log(ᶜe³mCURSED ITEM DESTROYED)sfx(44"end end iDENTIFY=function()id()call"sfx(55,-1,16,16"dialog(info)_g.selitem,_g.uimode=_ENV,"dISMISS"end dISMISS=popdiag getname=function()return isid()and(nid or n)..(lvl>0and"+"..lvl or"")or n end id=function()if not isid()then ided[typ]=true log(idprefix..getname())end end isid=function()return ided[typ]end rangedatk=function(e,t,n)function atkis(e)return n==e end local i,d=atkis"throw"and throw/12or.999,#t local n=t[min(flr(e*i)+1,d)]if atkis"lightning"then drawln=function(n)line(n.x+rnd(6)-3,n.y-2.5-rnd(3))end fillp()line(e%2*5+7)drawln(.5*(screenpos(pos)+t[1].tlscrpos))for n=1,min(e,d)do drawln(t[n].tlscrpos)t[n].lflashl=6end end function drawburst()spr(153,n.tlscrpos.x-2.5,n.tlscrpos.y-4.5)end n.initpal()if e*i>=d then if atkis"throw"then local e=n.ent or not n.tileflag"15"if lit and e then n.setfire()sfx"36"doatk(n)elseif orb and e then orbeffect(n)id()drawburst()else doatk(n)if n.tileflag"15"then setpos(n.pos,true)elseif throw and not ai then setpos(findfree(n,"item"),true)end end aggro(n)end return true end if atkis"blink"then(ai and _ENV or player).tele(t[d])return true end n.flatten()if atkis"throw"then function getpos(n,o)local n,e=i*n/d,d/i local e,n=(n*n-n)*e*e/4,lerp(pos,t[d].pos,n)local n=screenpos(n)+o return n.x,n.y+e,1,1,xface<0end if throwln then local n,t=getpos(e-1,vec2s"0,-2")local e,d=getpos(e,vec2s"0,-2")tline(e,d,n,t,18,throwln)else xface*=throwflp spr(typ,getpos(e,vec2s"-3,-6"))end elseif atkis"ice"then n.freeze(freezeturns)drawburst()else if e==1then gettile(pos).lflash=2end if atkis"fire"then trysetfire(n)if n.fire==0then create(138,n.pos)end n.entfire()end if dmg then if n.ent then n.ent.hurt(dmg)else aggro(n)end call"calclight(,t"end end end animtext=function(n)textanim=objtable("t:0,speed:0.03333,col:7,offset:-7,wavy:0,text:"..n)textanim.pos=entscreenpos()end entscreenpos=function()return screenpos(pos)+vec2(scrxoffset,-6.5)end setpos(t,true)while(rndlvl and rndp"0.33")eMPOWER(nil,true)
add(ents,_ENV)if flippable and rndp"0.5"then xface*=-1end yface=rnd{-1,1}checkidle()if behavis"sleep"then setanim"sleep"end return _ENV end function pickup(_ENV)if _ENV then if not beenfound then beenfound=true _g.itemsfound+=1end if#inventory<10or victory then sfx"25"add(inventory,_ENV)if victory then player.aimitem=player.setanim"victory"player.yface,player.statuses,tl.fire,light=-1,{},0call"setmode(victory)calcvis()calclight("end setpos()log("+"..getname())else log"INVENTORY FULL"end end end function turn(n,e)if getbtn(n)then player.diri=(player.diri+e)%6+1player.setanim"turn"end end function updateplayer()if player.taketurn()then player.tickstatuses()call"calcdist(pdist)calcvis("updateturn=function()calclight()for n,_ENV in inext,ents do if ai then taketurn()end if not isplayer then tickstatuses()end end updateturn=function()for n,_ENV in inext,ents do if ai and behavis"hunt"and not _g.pseen and not alwayshunt then setbehav"search"setsearchtl(lastpseentl)end if summoned and not summoned.alive then summoned=nil end canact,noice=true,player.statuses.FROZEN end updateturn=function()updateenv()updateturn=function()call"calclight(,t,t"updateturn,pseen=updateplayer end end end end end end function setsearchtl(n)if searchtl~=n then lastpseentl,searchtl=n,n calcdist("search",n)end end function aggro(n)setsearchtl(player.tl)calcdist("aggro",n,-4)for n,_ENV in inext,ents do if ai and alive and tl.aggro>=-3then if seesplayer()then setbehav"hunt"_g.pseen=true elseif behav~="hunt"then setbehav"search"end end end end function checkfall(_ENV)if _ENV and canfall and tl.tileflag"15"then sfx"24"setanim(fallanim)if(isplayer)calclight()
end end function destroy(_ENV)if _ENV then del(ents,_ENV)del(inventory,_ENV)setpos()end end function genmap(e,n)alltiles(function(_ENV)adjtl=nil end)genpos,cave,ents,pseen=e,not n,{unpack(inventory)}at("world:{},validtiles:{},inboundtls:{},tileinbounds:{},drawcalls:{}",_ENV)for n=0,20do world[n],tileinbounds[n]={},{}local d,i=max(10-n),min(30-n,20)for e=d,i do local t=vec2(e,n)local t=tile(tempty,t)world[n][e]=t add(validtiles,t)if n>0and n<20and e>d and e<i then add(inboundtls,t)tileinbounds[n][e]=t end end end alltiles(function(_ENV)for n,e in inext,adj do adjtl[n]=gettile(pos+e)end adjtl[0]=_ENV end)entropy,gentl=1.5,gettile(genpos)if n then genroom(gentl)else gencave(gentl)end call"postproc()setupdrawcalls("end function genroom(n)local n,d=rndint"8",n.pos local e=rndint(n+1)local n,e=minroomw+e,minroomh+n-e e=(e\4+1)*4n+=n%2local t=ceil(rnd(e-1))-2local t=d+vec2(-ceil(rnd(n-3)+1)+ceil(t/2),-t)t.x+=(t.x-genpos.x)%2t.y-=(t.y+2-genpos.y)%4function doroom(a)local i,l,r=t+-d,rndp"0.5",rndp"0.25"for t=0,e do local f=(d.y+i.y+genpos.y+t)%2i.x-=f local e=t==0or t==e for o=0,n do local t,d=o==0or o==n,d+i+vec2(o,t)local n=inbounds(d)if a then if not n or cave and d==genpos then return true end elseif n then local _ENV=n altwall,manmade=f~=0,true destroy(ent)if(e or t)and not(typ==tdunjfloor and l)then if rndp(r)and not altwall and not(e and t)then gentile(txwall,n)genned=ent else set(e and txwall or tywall)end else set(tdunjfloor)end end end end end if entropy<1.5and doroom"true"then return genroom(rndtl())end entropy-=.15+rnd"0.1"if entropy>=0then doroom()if rndp(.4-depth*.025)then gencave(rndtl())end genroom(rndtl())end end function gencave(n)if(n.typ==tempty)n.typ=tcavefloor
entropy-=.013if n then n.visitadjrnd(function(e)if not e.tileflag"4"then if inbounds(e.pos)and rndp(entropy)then gentile(n.typ,e)if e.tileflag"4"then if rndp(.005+depth*.001)then genroom(rndtl())end gencave(e)end end end end)end end function gentile(n,_ENV)local e=ceil(rnd"15")if(manmade)e+=16
set(mget(n,e))if depth==16and tileflag"15"then return gentile(n,_ENV)end local n=mget(n+1,e)flip,genned=rndp"0.5",true if n~=0then if n<64then bg=n else create(n,pos)end end end function postgen(n,e)n.postgenned=true n.visitadjrnd(function(_ENV)if tileflag"4"and not postgenned then if not genned then gentile(n.typ,_ENV)end postgen(_ENV,n.tileflag"4"and n or e)end end)end function checkspawn(_ENV,n,e,t)if navigable()and pdist<e and pdist>-1000and not item and(t or not ent)then return not n or create(mapping[n]or n,pos)end end function postproc()function ca(i)for n=1,20do calcdist("pdist",gentl)local n,t,e={},0,100alltiles(function(_ENV)if navigable()and pdist==-1000and(i or not altwall)then add(n,pos)end end)if(#n==0)return
for t=1,200do if#n==0then return end local t=rnd(n)local o=gettile(t)local i=rnd(split(o.manmade and not i and"1,2,4,5"or"1,2,3,4,5,6"))local n=adj[i]local f=t+rndint"18"*n local n=gettile(f)if n then if n.navigable()and n.tileflag"4"and n.pdist>-1000then d=hexdist(t,f)if d<e then e,besttl1,bestdiri=d,o,i end end end end if e<100then repeat besttl1=besttl1.adjtl[bestdiri]local _ENV=besttl1 local n=navigable()if not n then if tileflag"15"then if bestdiri%3==2then typ=tybridge else typ=txbridge flip=bestdiri%3==1end bg=thole elseif manmade then typ=tdunjfloor else typ=tcavefloor end end until n and pdist>-1000end end end ca()alltiles(function(_ENV)if tileflag"12"then set(thole)end end)postgen(gentl,gentl)ca()alltiles(function(_ENV)if typ==tempty and inbounds(pos)then if adjtl[2].tileflag"4"and adjtl[5].tileflag"4"then gentile(tcavewall,_ENV)end end end)ca"true"local e,n=0,0alltiles(function(_ENV)if typ==tempty then for e,n in next,adjtl do if n and n.tileflag"5"then typ=tcavewall end end elseif tileflag"14"and adjtl[4].typ==txwall then typ=txwall elseif pdist>-1000and tileflag"15"then e+=1end if checkspawn(_ENV,nil,0,true)then n=min(n,pdist)end end)if depth==16then repeat until checkspawn(rndtl(),201,n*.66)elseif e<3then alltiles(function(_ENV)if checkspawn(_ENV,nil,n+2.5+rnd(),true)then set(thole)destroy(ent)end end)end if not player then player=create(64,genpos)else add(ents,player)end do local _ENV=player setpos(genpos)call"calcdist(pdist)calclight()updateenv("animoffset.y,animheight,animclip=-21,1setanim(statuses.SLOFALL and alive and"slofall"or"fallin")end wanderdsts,fadetoblack={}for t=1,6do for n=depth,20do spawn=rnd(spawns[n])if(rndp"0.55")break
end local n,d,e=rndtl(),rnd{"sleep","wander"}for e,i in inext,spawn do local e=false n.visitadjrnd(function(_ENV)if not e and checkspawn(_ENV,nil,-4)then create(i,pos,d,t)e,n=true,_ENV end end)end end for n=1,7-depth\5.99do checkspawn(rndtl(),mget(64+rndint"59",24),-3)end function rband(n,e,t)for n=counts[n],t or depth/2.001do checkspawn(rndtl(),rnd(split(e,"|")),-3)end end call"rband(life,248)rband(slofall,249)rband(empower,250)rband(identify,251)rband(light,252)rband(wpn,132|133|134|135|316|317|318|319,0)rband(wearable,308|309|310|312|313|314,0)calcvis()calclight(,t,t,t"end function aim(n)aimparams,aimpos=n,playerdst setmode"aim"end function updateaim(_ENV,n,e)player.aimitem,aimscrpos,_g.aimscrposy=_ENV,screenpos(aimpos)+1.5*vec2(1.5*(tonum(btn"1")-tonum(btn"0")),tonum(btn"3")-tonum(btn"2"))_g.aimscrposx,_g.aimscrposy=mid(campos.x,aimscrpos.x,campos.x+127),mid(campos.y,aimscrpos.y,campos.y+127)_g.aimpos=vec2(aimscrposx/12,aimscrposy/8-aimscrposx/24)local n=hexline(player.pos,hexnearest(aimpos),unpack(n))for e,n in inext,n do if(n==player.tl)return
n.hilight=2end player.lookat(aimpos)xface=player.xface if getbtn"32"and#n>0and statet>.2then setmode"play"pos=player.pos if e=="throw"then sfx"12"player.aimitem=sTOW"true"del(inventory,_ENV)else id()charges-=1sfx(usefx)end player.setanim"throw"add(rangedatks,{rangedatk,{0,n,e}})elseif getbtn"16"then player.skipturn=false setmode"play"end end _g=at([[mode:play,statet:0,depth:1,btnheld:0,shake:0,invindex:1,btns:0,shakedamp:0.66
,tempty:0,tcavefloor:50,tcavefloorvar:52
,tcavewall:16,tdunjfloor:48,tywall:18,txwall:20
,tshortgrass1:54,tflatgrass:38,tlonggrass:58
,thole:32,txbridge:60,tybridge:44
,minroomw:3,minroomh:2
,stepstaken:0,itemsfound:0,creaturesslain:0
,specialtiles:{},spawns:{},diags:{},inventory:{},rangedatks:{},mapping:{}]],_ENV)entdata=at(chr(peek(32770,%32768)),nil,"\n","=")adj,fowpals,frozepal,ided,enchstats,tlentvars,itemslots,updateturn,counts=vec2list"-1,0|0,-1|1,-1|1,0|0,1|-1,1",{split"0,0,0,0,0,0,0,0,0,0,0,0,0,0",split"15,255,255,255,255,255,255,255,255,255,255,255,255,255",split"241,18,179,36,21,214,103,72,73,154,27,220,93,46"},split"1,13,6,6,13,7,7,6,6,7,13,7,6,7",at"130:,131:,132:,133:,134:,135:,201:",split"lvl,hp,maxhp,atk,throwatk,dmg,throwdmg,armor,darksight,recharge,range,charges,maxcharges,freezeturns",split"item,ent,effect",split"wpn,cloak,amulet",updateplayer,at"generic:0,wpn:0,wearable:0,life:-1,slofall:-1,empower:0,identify:0,light:0"foreach(split([[16
-9,-4
0,-8|5,-8|13,-8|13,4|4,4|2,4
5,13|8,13|5,13|5,4|11,4|3,4
◆32
-8,-4
0,0|4,0|13,0|0,0|4,1|13,0
4,8|8,8|3,8|4,8|7,7|4,8
◆20
-9,-2
12,-6|0,-8
4,13|12,17
◆18
-5,-2
9,-8|2,-8
6,17|7,17
◆54
-3,-4
1,0
7,7
◆default
-8,-4
1,0
15,8]],"◆"),function(n)local n,e,t,d=usplit(n,"\n")specialtiles[n]={vec2s(e),vec2list(t),vec2list(d)}end)for e=0,19do local t,n=add(spawns,{}),{}for d=64,127do local e=mget(d,e)if e>0then add(n,e)elseif#n>0then add(t,n)n={}else break end end end foreach(split([[172,173,174,175,188,189,190,191|248,249,250,251,252,253,254,255
140,141,142,143|308,309,310,311
156,157,158,159|312,313,314,315
129,145,161,177|316,317,318,319]],"\n"),function(n)local n,e=usplit(n,"|")local n=split(n)foreach(split(e),function(e)local n=del(n,rnd(n))entdata[n]..=entdata[e]mapping[e]=n end)end)genmap(vec2s"10,12")add(inventory,create(130)).eQUIP"true"player.setstatus"TORCH,160,160,2,9"call"calclight()print(⁶!5f5c	⁶)memcpy(0X5600,0xf000,0xdff"
__gfx__
fffffffffffffffffffffff000ffffffffff000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffff0100000fffffffff0000000ffffff0000000fffffffffffffffffffffffff155111551ffffffffffffffffffffffffffffffffffffffffffffffffffff
000ff00100011fff00fff0000000000fff00000000000fffffffffffffffffffff5fffffffff5fffffffffffffffffffffffffffffffffffffffffffffffffff
0010110150015f0000ff0000000000dff000000000000000ffffffff0ffffffff1fffffffffff1ffffffffffffffffffffffffffffffffffffffffffffffffff
001105015010500000f0000000000ddf000000000000000dfffffff00fffffff5fffffffffffff5ffffff055d5fffffffffffffffffffffffffff0055dffffff
001d0501101000100000000000001d1f555000000000001dfffffff0d0fffffff1fffffffffff1ffffff0511515ffffffffff000ffffffffffff055511dfffff
011d01011010101000550000000d11df1550550000000d11fffffff0d00fffffff5fffffffff5ffffff01055000dffffffff0555000fffffffff05115510ffff
0d010100000010000055505000dd11df000055505000dd11ffffff005d0f0ffffff155111551ffffffff0511511dfffffff051515550ffffffff01501115d0ff
0d0100000f0000000000505551d1d11f505000505550d1d1ffff00011d00d0ffffffffffffffffffffff050151d1ffffff05050151d5ffffffff01550101d0ff
0d10ffff0ffff00100500005511dd1df5055500005501dd1fff000011501d0fffff2dd222dd2ffffffff01011010ffffff5552050d510ffffffff0155d150fff
0110050fffffff0000505550011d1ddf0005505550001d1dff0500001101d00fffdfffffffffdfffffff01115d10f1ffff505555d151010ffffff0015500f1ff
010ffffffffff0f0000015505d111d0f555000155055111dff01100115001d00f2fffffffffff2ffffff01511550111ff050512151511110ffff00100100111f
0001fffffffffff1005500005d1d100f1550550000551d100111010111001150dfffffffffffffdffff05000000dffff0020505051550000fff05000000dffff
00001ffff00f50100055505001dd00fffff055505000dd00f011010110d01010f2fffffffffff2fffff105505550110ff051505050511100fff105505550110f
ff0000110000110000f0505551d00fffffff00505550d00fff0011010050100fffdfffffffffdfffff0011000001100fff555151d501100fff0011000001100f
fff0000000000000ffff00055100fffffffffff0055000fffff01111101110fffff2dd222dd2fffffff00110111000fffff00555511000fffff00110111000ff
ffffffffffffffffffffff0000fffffffffffffff000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff042222242fffffffffffffffffff
fffffffffffffffffffffffffffffffffffff0bbb00fffffffff3ffffffb3f33fff000110111ffffffffffffffffffffffff150000050ffffff000550111ffff
fffffffffffffffffffffffffffffffffff10bbbbbbbf1fff33ff3fff0b0f3ffff011d005111f10fffffffffffffffffffff005222202fffff0111000111f10f
fffffffffffffffffffff00ffff0ffffff10b11bbbbd111ffff3ff3f33ff3ffff01150dd1d5015d0ffffffffffff3fffffff050000050ffff011110110001110
1ffffffffffffffffffffff5f05f0ffffff055511b5dffffffff3f3fff3fbfff00005550050d0000fffffffffff3ffffffff042222240fff0000001111050001
fffffffffff1fffffff05ff05f00fffff01055155d501100fffffbfbffb00ffff011000050050100fffff3fffff3ffffffff021000100ffff001000010111100
fffff1ffffffffffffffff0fffffffffff0000155d01100fffff0b0bfbffffffff0011510050500fffffff3ffff3ffffffff042222242fffff0011110001100f
fffffffffffffffffffffffffffffffffff00100001000fffffffffbfffffffffff00150110005fffff3ff3f3ff3f3ffffff050000020ffffff00110111000ff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffff3ffffffffff555565555fffffff3f3f3f3ff3ffffffffffff505ffffffffff5ffffffff
fff000110111fffffff01111111110fffff01111111110fffffffffffbfffffffff5000d000005ffffff3f3ff3bf3ffffffffff5502202ffffff5055d11000ff
ff0111000111f10fff0111111111110fff0111111111110ffffffffffff3ffffff5011d01111106fffff3f3ff3b03fffffff05502202202fffff1000000055ff
f011110110001110f011100111111110f011111111111110fffff3fffffbfffff5011d0111111d05ffff3ff3f3ffbffff505202202205504fff15500d00555ff
000000111101000001111111111111110101111111111111fffff3ff3ffffffffd1110111111d01dfffff3f3fbffbfff022022022055044fff00555dd00500f1
f011000010111100f011111110011110f011111111100110fffffbf3fffffffff0d11111111101d0fffffbf3fbff00fff02202505404fffff051005d10d11100
ff0011110001100fff0111111111110fff0111111111100ffffffffbffffffffff0d111111d11d0fffff0b0bffffffffff055044ffffffffff001111055d100f
fff00110111000fffff01111111110fffff01111111110fffffffffffffffffffff0ddddd6ddd0fffffffffbfffffffffff44ffffffffffffff00510111000ff
fff67fffffffffffffffffffffffffffff11ffffff999fffffffffffffffffffff11f1ffffffffffff8888fffffffffffff7fffffffcfcffffffffffffffffff
fff62ffffffffffffff22ffffffffffff1001fff333333fffffffffffffffffff100101ffffffffff828228ffffcffffffc77fffffffcfcfffffff2989ffffff
ff888ffffff3f3fffff223fffff3f3fff1003fffb3333344ffffffffffff4f4f10000001ffffffff2f88fff2ffc7cffffcc777ffffffcdcffffff2982828afff
ff88dfffffbbb3f6ff22234fff44439f100038ffb3333b42ffffffffffff444f05000550fffeeefff8288228ffc7cfffffdccfffffffdddffffff9822282e8ff
ff88d6ffffbbbf6fff222f4fff4445f9100014ff4bbbb92ffff4f4ffff44422f11101111ffe227eff8f28288fccdccffffdccfffcffccdfff89ff9822282ffff
ff882fffffbbb3ffff22234fff222366100034fffbbbb4ffffff55fff44422fffff1ffffffe222eff2f28f2ffffcfffffffcfffffccdddffff89982225282fff
ff2f2fffff444fffff222f4fffddd99f10001ffff2222fffff5555ff442402ffffffffffffe20eef2228822ffffffffffffdfffff22d02fffff8822200528fff
ffd0dfffff202fffff222fffffd0dfff10001ffff2002ffffe544ffff202fffffffffffffe2222eff282882ffffffffffffffffff202ffffffff25025fffffff
fff67fffffffffffffffffffffffffffff11ffffff997fffffffffffffffffffff11f1ffffffffffff88d8fffffffffffff7fffffffcfcffffffffffffffffff
fff22ffffffffffffff22ffffffffffff1001fff333993fffffffffffffffffff100101ffffffffff822828ffffcffffffc77fffffffcfcffffffffe99ffffff
ff882ffffff3f3fffff323fffff3f3fff13031ff99333bffffffffffffffffff10500001ffffffff2f88fffeffc7cffffcc777ffffffcfcfffffff988898ffff
ff8d9fffffb333ffff2333ffff4333ff103331ff99b33b44ffffffff4fffffff05580850fffffffff8288228ffc7cfffffdccfffcfff6c6ffffff9828289a8ff
ff86dfffffbbbff6ff222f4fff44299f1000181f499bbf42ffffffff24424f4f11101111fff88ffffef28282fccdccffffdccffffccfdcfff89ff9822828e88f
ff826fffffbbbf6fff222f4fff2445f91000141ff449942ffef4f4fff422444ffff1ffffff28e8fff2f28f2ffffcfffffffcfffffddcddffff2998222822ffff
ff2f2fffff44b3ffff22234fffdd43661000341ff2244fffff5555fff204240ffffffffff2d888fff288822ffffffffffffdfffff20d22fffff2222252802fff
ffd0dfffff202fffff222f4fffd0d99f100011fff2002fffff0555fffff202ffffffffff2822dd2f2882802ffffffffffffffffffff202ffffff2250052802ff
ffffffffffffffffffffc4cffffffffff11fffffffffff6fffffffffff6fff6f11ffff11ffffffffffffffffffcccffffff7ffffffffffffffff8fff9a8fffff
fff67fffffffffffff2ec4cfffffffff1041fffffffffff6fffffffffff64f460011f100fffffffff828ff28ffffccffffc77efffffffffffff888f98e0fffff
fff88fffff7666ffff223c4cfff3f3ff100a1f8fffff9996f6ff6ffffff6444650001005ffffffffff8f8888fffffccfecc777eeff2c7c7fff855889822f88ff
ff8886fff763f36fff22223cff4443ff10001878ff333336ff4f46fff4f4442615000051ffffffffff828288fffcfccfffdccffffff2c7c7fffff5898888858f
ff88dffff3bbb3f6ff222ec4f4444f9f1000438ff33333b6ff6556ffff444226f100051fffffffffff888288fffcc77cffdccfffcf2cddd7ffffff8982255fff
f8822fffffbbbfffff22efc4ff224f9f10000ffff333bb94ff5555fff4244f2fff1011ffffeeeeeff2882f88ffcd7ccffffcfffffccdd2dfff89ff89822fffff
ff2f2fffff444fffff22effcffddd9ff10001ffff2222942ff544fffffff4ffffff1fffffe22227e28882288fffccffffffdffffd2dfdffffff8999822ffffff
fd00dffff4004fffff222fffffd0dfff10001fff200002fffe5fffffff00ffffffffffffe222002e8288822efffcffffffffffffffffffffffff8882250fffff
fffffffffffffffffffffcfffffffffff11fffffffffffffffffffffffffffff11ffff11ffffffffffffffffffffcffffff7ffffffffffffffffffff9a88ffff
fff67fffffffffffff2ec4cfffffffff1041ffffffffff6fffffffffffffffff0011f100ffffffffff28ff28fffffcffffc7efffffffffffffff8ff98e0fffff
fff22fffffffffffff3234cffff3f3ff1a0a1fffffff9996ffffffffffffff6f50001005ffffffffffff88d8fffffccfeeee7eeeff2d7c7ffff88888828f28ff
ff822ffffff3f36fffbb3c4cff4333ff133a1f8fff333976ffffffff4f624f4615000051fffffffff8882282ffccfccfffdcefffcff2c7c7ff8558582222858f
ff6d9fffffb333f6ff222e3cff44499f10001878f3333336ff64f6fff4464446f158081ffff22ffffff88228fcdccccfffdccffffccdc7c7ffffff982255ffff
f86226ffffbbbff6ff222ec4f4425ff910004a8ff94bbb66fef6556f42462406ff1011ffff288e2ff2882f28fcc7ccfffffcffffddd26c6fff89ff98222fffff
ff6f2fffff44bf66ff22efc4ff435ff9100001fff9924446ff56556fff262f26fff1fffffd88882f28882228fffc7cfffffdfffffffd2cffffff998222ffffff
fd00dffff4002377ff222fffffd0d99f10001fff29444426ff55ff5ffff4fff4ffffffff282d8d2f882e822effffcfffffffffffffdfdfffffff2262250fffff
fff67ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fff62fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff99ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff888fffffffff3fffffffffffffffffffffffffffffffffffffffffffffffffff899ffffffffffffffffffffffffffffff40ffffff50ffffff94ffffff65fff
ff88d6fffffff44ffffafffffffffffffffff7fffffffffffffff4ffffff97ffff998ffffffccffffff8fffffffffcffff4ff4ffff5ff5ffff9ff9ffff6ff6ff
ff88dffffff4400ffff9fffffff5ffffffffdfffffff7fffffff5d6fffff997fff544fffffccc7ffff8ffffffffffffffff49ffffff56ffffff9affffff67fff
f8822ffff4400ffffff4fffffff4fffffff4ffffff56fffffff4f6fffff5f9fffff5ffffffffdffff898ffffffffffffff4fffffff5fffffff9fffffff6fffff
ff25fffff00fffffffffffffffffffffff4fffffff5fffffff4fffffff5fffffff554ffffcf2d2fff8998fffffffffffffffffffffffffffffffffffffffffff
ff0dfffffffffffffffffffffffffffff4ffffffffffffffffffffffffffffffff505ffffdf00fffff88ffffffdfffffffffffffffffffffffffffffffffffff
fff67ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fff22fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff899fffffcfcfffff8fffffcfffffffffffffffffffffffffffffffffffffff
ff882fffffffffcfffffffffffffffffffffffffffffffffffffffffffffffffff998ffff7fdf7fff998ffffffffffffffff9fffffffdfffffff3fffffffcfff
ff8d9ffffffff66ffffaffffffffffffffffffffffffffffffffffffffffffffff998fffcfdfdfcff8998ffffffff7ffff9999ffffdd5dffff3333ffffccccff
ff86dffffff6600ffff9fffffff5ffffffffffffffffffffffffffffffff97ffff454ffffdfffdff899998fffffffffff4490ffff5550ffffbb30ffffddc0fff
f82626fff6600ffffff4fffffff4ffff44ffffffff567ffffffff4fffff5997ffff5ffffcfdfdfcf8999998ffffffffcf900fffff500fffff300fffffc00ffff
fff22ffff00fffffffffffffffffffffff44ffffffdfffffff445d6fff5ff9ffff554ffff7fdf7ff8899998ffffffffff0fffffff0fffffff0fffffff0ffffff
ff0dffffffffffffffffffffffffffffffffd7fffffffffffffff6ffffffffffff505fffffcfcffff88888ffffcfffffffffffffffffffffffffffffffffffff
fffffffffffffffff988fffffffffffffffffffffffffffffffffffffffffffffff9fffffffffffff88fffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffa9998fffffff5ffffffffff7fffffff7f66676fffffff6ffff998fffffffffff8988ffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffff8f9fff98fffffffdffffffff6fffffff7f656ff67fffffff6fff999ffffffdfffff88ff8ff7fffffffffffffffffffffffffffffffffffffff
fffffffffffff55ff4fff98ffffff5fffffff46fffff566f64ffff67ffffff6fff899fffffd5fffff898fffffffffcffff3c3fffff4a4fffff282fffff5d5fff
fffffffffff5500ffffffffffffffd5fffff4fffffffff6fffffff66fffff66fff554fffff51bbff899988fffffffff7ffc37fffff947fffff827fffffd07fff
fffdd8fff5500fffffffffffffff445ffff4ffffffffff6ffffffffffffff66ffff5ffffff5bb5ff8999998fffffffffff3c3fffff494fffff282fffff5d5fff
f2288887f00ffffffffffffffffffffffffffffffffff6ffffffff66fff5557fff554fffff5155ff8999998fffcfffffffffffffffffffffffffffffffffffff
d8888886fffffffffffffffffffffffffffffffffffffffffffffffffffff99fff505ffff0505ffff88888ffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffff66ffff6ffffffffffffffffffff8fff8ffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffff5ffffffffffffff6fffffffffffffffff6ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffeffffffffffffff5ffffffffffffff6fffffffff66fffff6ffffffffffffffffffff8fffffcffffcffffffffffffffffffffffffffffffffff
fffffffffffff22fffffff9ffffffdfff44fffffffff6fffffffff66ffff66fffffffffffffffffff8988fffffffffffffbdbfffff898fffff2e2fffff8e8fff
fffffffffff2200ffffff98fff4ff5fffff446ffff566fffffffff7fff5f66fffffffffffffbbbff8999988ffffffffcff3b7fffff987fffffd27fffffe87fff
ff8888fff2200fffff4998fffff4dffffffff46fffff7fff6f4ff6fffff577ffff54f4ffff5550ff8899998fffffffffffb3bfffff898fffff2d2fffff8e8fff
f826d226f00fffffffa98fffffff5fffffffff67fffff7ff656667ffffff99fffff555fffb51110ff88988ffffffffffffffffffffffffffffffffffffffffff
d66d9227fffffffffffffffffffffffffffffffffffffffff667ffffffffffffff5505ff555550fff88888ffff7fffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffff000ffffffffff000fffffffffffffffffffffffffffffffffffefefffa999888876555555ffffffffffffffffffffffffffffffff
ffffff0100000fffffffff0000000ffffff0000000fffffffffffffffffffffffffffffffe757eff544fffff76655555ffffffffffffffffffffffffffffffff
000ff00100011fff00fff0000000000fff00000000000fffffffffffffffffffff222ffffe656eff76d44444ffffffffffffffffffffffffffffffffffffffff
0010110180018f0000ff0000000000dff000000000000000ffffffff0ffffffff22222fffe6564efffffffffffffffffffffffffffffffffffffffffffffffff
001108018010800000f0000000000d9f000000000000000dfffffff00fffffff022224fffe5e5efffffff055d5fffffffffffffffffffffffffff0055dffffff
0019080110100010000000000000191f555000000000001dfffffff0d0fffffff12444ffffefefffffff0511515ffffffffff000ffffffffffff055511dfffff
011901011010101000550000000d119f1550550000000d11fffffff0900fffff021114fffffffffffff01055000dffffffff0555000fffffffff05115510ffff
0d010100000010000055505000dd119f000055505000dd11ffffff005d0f0ffff02440ffffffffffffff0511511dfffffff051515550ffffffff01501115d0ff
090100000f0000000000505551d1911f505000505550d1d1ffff00011d0090ffffffffffffffffffffff05015191ffffff05050151d5ffffffff01550101d0ff
0d10ffff0ffff00800500005511d919f5055500008801dd1fff000011501d0ffffffffffff757fffffff01011010ffffff5552050d510ffffffff01549150fff
0110050fffffff0000505550011d19df0005505580001d1dff0800001101d00ff242ffffff656fffffff01118910f1ffff5055559151010ffffff0015500f1ff
010ffffffffff0f0000015505d111d0f555000158058111dff01100115001d0024224fffff6564ffffff01511550111ff050512151511110ffff00100100111f
0001fffffffffff1005500005d1d100f1550550000581d10f111010111001150222444fff8a8a8fffff05000000dffff0020505051550000fff05000000dffff
00001ffff00f80100055505001dd00fffff055505000dd0ff011010110d01010122444fff89898fffff105505850110ff051505050511100fff105505450110f
ff000811000011000000505551d00fffffff00505880d0ffff0011010050100f012444ffff8f8fffff0011000001100fff5551519501100fff0011000001100f
fff0000000000000ffff00055100fffffffffff005500ffffff01111101110fff0122ffffffffffffff00110111000fffff00555511000fffff00110111000ff
ffff115515150fffffffff0000fffffffffffffff000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff042992242fffffffffffffffffff
fff11015010105ffffff001500fffffffffff0bbb00fffffffff9ffffffb9f33fff000110111ffffffffffffffffffffffff150000050ffffff000880811ffff
ffd110111101011ffff10011015ffffffff10bbbbbb8f1fff33ff9fff0b0f3ffff011d005111f10fffffffffffffffffffff005222202fffff0111000111f10f
fd11001101000101ff1d1000011001ffff10b11bbb9d111ffff3ff3f99ff3ffff01150d9195015d0ffffffffffff9fffffff050000050ffff011110180001110
5151000000000100f155000100000155fff05551195dffffffff3f3fff3fbfff00005550050d0000fffffffffff9ffffffff042922240fff0000001111080000
11500011010000011150f00011000011f01155155d501100fffffbfbffb00ffff011000050050100fffff9fffff3ffffffff021000100ffff011000010111100
1101fffffffff1015001ffff00000100ff0000155d01100fffff0b0bfbffffffff0011510050500fffffff9ffff3ffffffff042222242fffff0011110001100f
101fffffffffff01500ffffffff00001fff00100001000fffffffffbfffffffffff00150110005fffff3ff3f9ff3f3ffffff050000020ffffff00110111000ff
ffffff88fffffffffffffff888ffffffffffffff88fffffffffffffff9ffffffffff555979555fffffff3f3f3f3ff3ffffffffffff505ffffffffff5ffffffff
fff000110881fffffff01111111110fffff01111111110fffffffffffbfffffffff5000d800005ffffff3f3ff3bf3ffffffffff5904202ffffff5055d11000ff
ff0111000111f10fff0111111111110fff0111118111110ffffffffffff9ffffff5011d08111106fffff3f3ff3b03fffffff05902902202fffff1000050045ff
f011110180001110f011100111111110f011111111111110fffff9fffffbfffff5011d0181111d05ffff3ff3f3ffbffff505502402405504fff15500d55455ff
000000111101000001111118111111110101111111111111fffff3ff9ffffffffd1110111111d01dfffff3f3fbffbfff022022022055044ff0005559d0550001
f011000010111100f011111110011110f011111111100110fffffbf3fffffffff0d11111111101d0fffffbf3fbff00fff02202505404fffff051005910d11100
ff0011110001100fff0111111111110fff0111111111100ffffffffbffffffffff0d111111d11d0fffff0b0bffffffffff055044ffffffffff0011110559100f
fff00110111000fffff01111111110fffff01111111110fffffffffffffffffffff0ddddd6ddd0fffffffffbfffffffffff44ffffffffffffff00510111000ff
__map__
000000000000000000000000000000001011ca0014150000000000001c1d000020210000242500002829000000002e2f303132333435363738393a3b0000000046004646004600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003200cb0000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000046004646004700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003200000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000046460047470041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000046460047470041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000047474700414100410041420048004900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000047474700414100410041420048004900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001600000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000041414100414200430048480049000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001600000000000000000000003200000020000000320000003200000000003200320032003200363400003a340000000041414100414200430048480049000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001600000000000000000000003200000020000000320000003200000000003200320032003400363400003a340000000041414200414300494900484848004500414243440043430000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001600000000000000000000003200000020000000320000003200000000003200320032003400363400003a340000000041414200414300494900484848004500414243440043430000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000016000000000000000000000032000000200000003200000032000000000032003200340034003a3200003a340000000041434442004141424200414143430045004545004d4d004249004848480000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000016000000000000000000000032000000200000003200000032000000000032003200340034003a32000036320000000041434442004141424200414143430045004545004d4d004249004848480000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000032890000000000000000000032000000200000003200000032000000000032003200340034003a340000363200000000424949004d4d4d004c00454500454200444448484800000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000328900000000000000000000320000001000000032000000320000000000320032003400200032000000363200000000424949004d4d4d004c00454500454200444448484800000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003489000000000000000000003200000010000000320000003200000000003200320034003632320000003634000000004545424444004c4d4d4d004444484848480042424949000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003489000000000000000000003200000034000000320000003200000000003200320032003634340000003634000000004a004e004545424444004c4d4d4d0044444848484800424249490000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001011000014150000000000001c1d000020210000242500002829000000002e2f303132333435363738393a3b000000004a004c4d4d4d004e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a30000000004a004c4d4d4d004e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a30000000004a004c4d4d4d004e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a30000000004a004c4d4d4d004e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000030000000000000002ec80000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002e000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002e0000000000000030000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002e0000000000000030000000200000002ea900003000000000001c00300030003000363000003a2e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002e0000000000000030000000200000002ea900003000000000002ea930003000300036300000363000000000acadaeafbcbdbebfacadaeafbcbdbebfacadaeafbcbdbebf848586878191a1b18c8d8e8f9c9d9e9f848586878191a1b18c8d8e8f9c9d9e9ffdfeff0000000000
00000000000000000000000000000000000000003e0000000000000030000000200000002ea9000030000000000028003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000003e0000000000000030000000200000002ea900003000000000002ec83000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000003e0000000000000030000000200000002ea9000030000000000024003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001e0000000000000030000000200000002ea9000030000000000030882e0030003000362e000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001a0000000000000030000000200000002ea900002e000000000020002e002e002e003a2e0000362e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002ec800000000000030000000200000002ea900002e000000000036302e002e002e003000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000308800000000000030000000300000002ea900002e0000000000362e2e002e002e002e0000002e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
000000000000000000000000000000004000004800082c0000006e003e006e007a8163013a016b03f32109096b153321332173217321730323017d036b156a0104040404000000000000000000000000040404040000000000000000000000000404040400000000000000000000000004040404000000000000000000000000
0000000001010101008000000000000000000000010101010000000000000000040000000101010300000000000000000400000001010103000000000000000001010000000000000000000000000000010110002000700000003000300030000000000010000407040100090401040004000407040004070400040904003000
__sfx__
39500810220342202022010220122201022010220150060518500185000f5000f5001350013500165001650018500185000f5000f5001350013500165001650018500185000f5000f50013500135001650016500
900100000064000620006100061000610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9205000017631276702c6702f6703167033670316703267030671316712f6602cf7029f702af7026f602af5126f5125f5125f4020f411ff411ef301df311cf301bf211af2119f2018f1116f1115f1113f1105f01
c4281400184151a4151f41521415184151a4151f41521415184251a4251f42521425184251a4251f42521425184251a4251f415214152140523405284052a4050000000000000000000000000000000000000000
48030c1c0862424524240242404124051240412403124021240212402124021240212403124031240412404124031240312402124021240312403124041240412403124031240212402124011240112401123011
490800000a05301030010210102101015010000100001000010000100000000000000800301000010000905301030010210102101015006450051300503050050000000000000000000000000000000000000000
520a100000605006053a6053a6053b615000053b6253a6053b6150000000000000003d6103d615000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9303002000661026510c6710267008661016310866001661106710366009641026610567006651016710b640066610167103670046510267109640016610a671026400466103671076310b650036610667103631
9127002005f7113f7111f7112f7108f7110f711af710df7115f7105f7121f710df7112f7118f7104f7106f7112f711bf7110f710ff7106f7104f7111f710ff710cf7115f7118f7104f710cf7111f710bf710ff71
520709003e65331651006113e62330621006113e61311611006150060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
900207000f9140f9300f9450f9030f9200f92509a0009a0009a0009a0009a0009a000060000600006000060000600006000060000500005000060000600005000050000500005000050000500005000050000000
00020a001414015151151611216111141061330613105121051200512102100011000210003100031000210003100081000810000100001000010000100001000010000100001000010000100001000010000000
900117000062000621056310a64112641186512065110051060310302101621006210262000610006100061000610006000061000600006100000000610000000000000600000000000000000006000000000000
a8020600322303f2613e2413c231342010b2002e2002f2002320000200002000020000200002002d2001d20000200002000020000200002000020000200002000020000200002000020000200002000020000200
aa0506003e6143a5213f5213f5113d501005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
aa0407003e6143e5213f521355112f511005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
d402170000120071501a2701665013260122601015009250041500e15000250052000024004200031000023000100001000023000100001000010000100001000010000100001000010000200002000020000200
d4080a00170033e544345353d5353e525345153d5153e51531507375073a5073d5073a50732507325073a5073b5072f50732507375072b5073750721507285070050000500005000050000500005000050000500
40051000005003c020005003201000500370102a500005003c50000500005000050000500005000050000500005003c000005003200000500370002a500005000050000500005000050000500005000050000500
010706000000109071190010000107031200010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c403110000610022210a631241412c3401a641132310a221066200000001220000000120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c4020b00326103503437061242311d213102310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
220411002d6210a0530f12104131061520813208152081320e1510812108141071410814107121091410e1110b101071010a1010a105000000000000000000000000000000000000000000000000000000000000
900409000f65500301000010065006011006013600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
900b04003f00438011320212900100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
480606000062507071000000062400620006250000001605006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
940310000165500000206650051106531095110b521095110a5210b5010a5110b5010c5010b5010a5110b50100000000000000000000000000000000000000000000000000000000000000000000000000000000
c40406003a62532525136003f52500605026010160100505006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
060212000655300003095530000300003115333f5153f5051a533000030000335545206153b515000003b5003f500000000000000000000000000000000000000000000000000000000000000000000000000000
36030b003d60135211006113e5113e5113a511385013e5003a5013850100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000114000915009161091710b1700a171091500416102150021300113101150011610117102170031610317002171031700815108130001000010000100001000010000100001000010000100001000010000100
d40220000015000250002500f6600f2600e2500915009650091500425009150052500325004250031500125000100002500010000100002500010000230001000010000100001000023000200002000020000200
a8011700322103e2313f2313f2312f200232002e2002f20023200002000020000200002003020038201272022f221392513d2513d251002000020000200002000020000200002000020000200002000020000200
900119000061000611026210862117621236313063123631166210c01105611006110261000610006100061000610006000061000600006100000000610000000000000600000000000000000006000000000000
4c0603000667306573005530d503005030c5030050500103001010010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000000000000000000000
9001190019920199201992019920199201992019920199200d9000d9000d900059100591005910059100591005910059100591005910059100591005910059100b9000b9000b9000b9000b9000b9000b9000b900
4a020000017742f641056600a671136710965003641026413663005621036310562008621056310e630056210162100610096110061100620006312d621006110061001601016210160100610006210060100611
490210000261000620036100161000600006100061000610006000061000600006000050000500006150060000500005000050000500005000050000500005000000000000000000000000000000000000000000
79020b000e91006010040110301500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a9030800260242a011001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000000000000000000000000000000000000000000000000000000000
970108003b5253461034615270000000000000000000000000000000002b6002e600395053060330605306003930030600306001a6052900029000290053b6000000000000000003b600000003b600000003b600
90070b001967316333073130060315333073131530315303153130830000100001000010000100001000010000100001000010000100001000010000100001000010000100001000000000000000000000000000
000b02000f05300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90010d0007615006110061524500316000060000600006003162500610006110060100601006011e60500601006010060100601006051d600006050560004600000000060500000000000a600086050000002600
680809001407323024220112101121001195011950100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7e0200000c050006500145033650366603666036660366503665036650366503665036650366501764017630176301333000000123501760025600206001133000000296002a600003000c310000000000000000
7e0219000c0500065001450386503a6602766020660163502d65014350366003660015350366001760017600176000040000000000001760025600206000030000000296002a6000030000000000000000000000
30070c003e511365203a5253a5113a5123a5153a50231502315020000100001000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
300609003f521305203052539515395023a5053a50231502315020000100001000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0802000012120141211b14220140201302014020130191201b1301c1401c1321c1421d1421d1121d1121d1421d1121d1121d1421d1121c1121c1451c1101c1000000000000000000000000000000000000000000
0902000030121301212a1212614222140221302214022130211201e1301e1301e1221e1221e1221e1121c1211b111191211c1021c1021b1021b1051a1001c1000000000000000000000000000000000000000000
c004000000656046560a666071761167612676156761567614676176761767617676176661566613666106560e656096560865607656066560565602641006310363101621026210061100611006010020100000
90020000006560465602666081761167612676156761567613176176761767617676176661116613666106560e656096560865607656066560565602641006510263103631016210162100611006010020100000
35040d003550135521355223551235512355110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
910600000f60102011080110d6111402119621230313a6113f6010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
400510001f501375513c5001f501375213c5001f501375113c50000500005000050000500005000050000500005003c000005003200000500370002a500005000050000500005000050000500005000050000500
04a014001882018820188251b8001c8001e8101e8241e81518c001bc001f8101f8101f815240002a8001f8201f825158000000000000000000000000000000000000000000000000000000000000000000000000
6da00014155141e52621517155120e5111e5141e5141e502175141f5061c51418516185121a5111a5121b5111b5141b5121b5121b5133f5000050000500005000050000500005000050000500005000050000500
6050000014e0424e2015c2415c301ac541ac401ac301ac301ac2015c3019c3019c4019c3419c351bc000000000000000000000018c2418c5418c5018c3018c4018c541cc161cc301cc301cc2017c5016c5416c55
00a0140019d7019d7019d7019d7019d0019d7018d7018d7018d0018d7017d7017d7017d7017d7017d0017d701dd701dd7027d00000001dd000000000000000000000000000000000000000000000000000000000
90a014001fb441fb401fb441fb401fb351de301eb441eb401eb201eb201fb441fb401fb441fb401fb2020b4420b4020b3020b2020b10000002d4002c400000000000000000000000000000000000000000000000
04a014001782017820178251fc0023c0516820168341682524c001bc0017820178201782500000000001482014825000000000000000000000000000000000000000000000000000000000000000000000000000
6050000028c0411c001bc0015c301ac541ac401ac301ac301cc2417c5018c5418c5018c3418c351bc000000000000000000000028c0411c001bc0015c0015c331ac541ac401ac301ac301cc2417c5016c5416c55
00a014001ed701ed001ed701ed701ed001ed701dd701dd701dd001dd701cd701cd001cd701cd701cd001cd7018d7018d7027d0018d001dd00000001dd00000000000000000000000000000000000000000000000
__music__
01 3d3c3f7c
00 3d3f3e7c
00 3d3c3e7c
00 3d3c3b7c
00 3d3c3f7c
00 3c3f3e7c
00 3d3f3e3c
02 3d3b3a3c
00 3d3b397c
00 3d3f3e3c
02 3d3b3a3c
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 3d383c6a
01 3d3c3b7c
02 3d387c3f
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
03 08424344
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000h0100000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000001h000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000001000000h5000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000100011hhd000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000010110150015d0h000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000001105015010550h014111212000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000010001d0501101005h0h01000001h00000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000001100010011d010110101hhdh10211150000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000010151005101d0101000000115h101000005000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000011050105105d01011551515111h04111212000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000001d000101105d10110150101hh1000h000h1000000000000010000000000000000000000
0000000000000000000000000000000000000000000000000000000011d01010110111d110111101hh0h122111220000000000000h1000000000000000000000
00000000000000000000000000000000000000000000000000000000d010100000011d110011010010h0010000050000000000000h0100000000000000000000
00000000000000000000000000000000000000000000000000000000d01051515511515100000000000000000000000000000000010000000000000000000000
00000000000000000000000000000000000000000000000000000000d1012dd222dd21500011010100001111111110000h000000000h00000000000000000000
0000000000000000000000000000000000000000000000000000000000dd101111011d010100000000011111111111000000000h0h0h00000000000000000000
00000000000000000000000000000000000000000000000000000000010100101100102000000000001111111111111000000000000100000000000000000000
00000000000000000000000000000000000000000000000000000000011000000000000d00000000011111111111110100000000000000000000000000000000
00000000000000000000000000000000000000000000010000100000019001106700002000000000051100111111111h00000000000000000000000000000000
0000000000000000000000000000000000000000000001000010001111900000620a0d000000000001101111111111dh00000000000000000000000000000000
00000000000000000000000000000000000000000000000010150015d0102dd888d920000000000001011111111115h100000000000000000000000000000000
00000000000000000000000000000000000000000000000050150105901000088d04000000000000010011551515111h00000000000000000000000000000000
00000000000000000000000000000000000011111111001050110100d10011188d61100000000001000110150101hh100h000000000000000000000000000000
0000000000000000000000000000000000d111111111100010110101110011188211110001000000010110111101hh0h0000000h000000000000000000000000
0000000000000000000555000000000001d11111111101001000000110111112120011100000000000010011010010h000000000000000000000000000000000
00000000000000000001550550000000d111111111111110000000000011111d0d11111100000000000000000000000000000000000000000000000000000000
0000000000000000000000055505000dd11100111111111011101111101111001111111100000000000000110101000000000000000000000000000000000000
0000000000000000000505000505550d1d101111111111015011111111011111111111d100000000000001000000000000000000000000000000000000000000
00000000000000000005055500004401dd10111111111011100111111110111111111d1100000000000000000000000000000000000000000000000000000000
00000000000000000000005505540001d1d000000000011111111111111151515511515100000000000000000000000000000000000000000000000000000000
0000000000000000000555000154854111d00011011100111111100111111010510111500100000000000000000000000000000h000000000000000000000000
00000000000000000001550550089941d1011100011101011111111111d00011110111010000000100000000000000000h000000000000000000000000000000
0000000000000000000000055509980dd011110110001110111111111d0000000100101000000000000000000000000000000000000000000000000000000000
0000000000000000000000000509980d000000111101000051515511500000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000045401001100001011110010105101000000000000000000000000000001000000000000000000000000000000000000000000
00000000000000000000000111005001010011110001100010111100000000000000000000000000000000000001000000000000000000000000000000000000
00000000000000000000001111055400111001101110000100101100000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000150501000000000000001d00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000110111001100001011110000110111015501101100000000000000000000000000000000000000000h000000010h0000000000000000000000
0000000000011100011101001111000110011100011111000000000000000000000000000000000000000000000000000h10000hh00000000000000000000000
00000000001111011000111001101110001111011000111000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000111101000000440000000000111101000000030000000000000000000000000000000000000000000000000000000000000000000000000000
001101110011000010111100001104410011000010111100011j0110000000000000000000000000000000000000000000000000000000000000000000000000
00000111010011110001100111000111010011110001100103110000000000000000000000000000000000000000000000000000000000000000000000000000
0000000011100110313000111101400011100112221000111j001103110000000000000000000000000000000000000000000000000000000000000000000000
000000000000000j3330000000111101000000222220000001013113000000000000000000000000000000000000000000000000000000000000000000000000
000000000000001jjj1160110000101111000022224100011110130j011000000000000000000000000000000000000000000000000000000000000000000000
0000000000d1110jjj16010011110001100111124441010011000j11100000000000000000000000000000000000000000000000000000000000000000000000
000000000h5111044j30111001101110001110211140111000111011000000000000000000000000000000000000000000000000000000000000000000000000
5000000051h0001202010000000000000000000244050001000j0000000000000000000000000000000000000000000000000000000000000000000000000000
550500055hh10000101111000055011100010000101111000hh10hh0000000000000000000000000000000000000000000000000000000000000000000000000
05055505h51011110001100111000111010011110001100h0j1h000hhh0000000000000000000000000000000000000000000000000000000000000000000000
00005501d5h00110111000111101100011100110111000h111001h031hh000000000000000000000000000000000000000000000000000000000000000000000
0555000h5150000000000000001111050001000j00000000010hj1hj000000000000000000000000000000000000000000000000000000000000000000000000
0155055hhh500011100000010000101111000hh10hh0000hhhh0hj010hh000000000000000000000000000000000000000000000000000000000000000000000
5000055h5h0h01j111j10h00111100011000001h000hhh00hh00011hh00000000000000000000000000000000000000000000000000000000000000000000000
5505000dd0h0jhhjj11d1hh001101110000000000h031hh000h110h1000000000000000000000000000000000000000000000000000000000000000000000000
050555050000151hhj15000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100550110h011h11510hh0000hh2h2h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1114a40111000011150hh00hhh000150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1119470011100h0000h000h11h055110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11149411111100000000000000212400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
050001111110hhhhhhhhh0hh0000h0h0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11000011000hhh1hhh1hhh00hh1h0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000h110011hh11hh00hh01hh0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000hhh1hhh1hhh1hh00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000hhhhh00010hh000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000h10000hh00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00200000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00220022000000000000000000222002002200022022000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00202020200000000000000000020020202020200020200000000000000000000000000000000000000000000000000000000000000000000000000000000000
00202020200000000000000000020020202200200020200000000000000000000000000000000000000000000000000000000000000000000000000000000000
00202022200000000000000000002002002020022020200000000000000000000000000000000000000000000000000000000000000000000000000000000000
0hhhhh2hhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhh000000000000000000000000000000000000000000000000000000000000000000000000000000000
0h88888888888888000000h00h99999999999999999999h000000000000000000000000000000000000000000000000000000000000000000000000000000000
0h22222222222228000000h00h22222222222222222229h000000000000000000000000000000000000000000000000000000000000000000000000000000000
0h22222222222228000000h00h22222222222222222229h000000000000000000000000000000000000000000000000000000000000000000000000000000000
0hhhhhhhhhhhhhhhhhhhhhh00hhhhhhhhhhhhhhhhhhhhhh000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__meta:title__
keep:iNTO rUINS cART 2
keep: