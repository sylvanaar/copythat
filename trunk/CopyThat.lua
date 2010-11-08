
CopyThat = {}

CopyThat.lines = {}
CopyThat.str = nil


BINDING_HEADER_CopyThat = "CopyThat!"
BINDING_NAME_copymouse = "Copy Mouseover Frame"
BINDING_NAME_copytooltip = "Copy Game Tooltip"

SLASH_COPYTHAT_COPYFRAME1 = "/copythat"
SLASH_COPYTHAT_COPYFRAME2 = "/cpyt"
SlashCmdList["COPYTHAT_COPYFRAME"] = function(msg) CopyThat:ParseCmd(msg) end

function CopyThat:ScrapeMouseoverFrame()
    CopyThat:ScrapeTopFrame(GetMouseFocus())
end


function CopyThat:ScrapeGameTooltip()
    CopyThat:ScrapeTopFrame(GameTooltip)
end




function CopyThat:ParseCmd(msg)
    local frame = getglobal(msg)
    
    if frame and frame.GetName then
       self:ScrapeTopFrame(frame)
    else
        DEFAULT_CHAT_FRAME:AddMessage("CopyThat: Usage /cpyt <Frame>")
    end
end


function CopyThat:ScrapeTopFrame(frame)
    if frame == nil then return end

    CopyThat.lines = {}

    local name = frame:GetName() or ""
    self:ScrapeFrame(frame)

    self.str = table.concat(self.lines, "\n")

    CopyThatText:SetText(name.." Text")
    CopyThatFrameScrollText:SetText(self.str)
    CopyThatFrame:Show()
end


function CopyThat:ScrapeFrame(frame)
    if frame == nil then return end
        
    local lines = { frame:GetRegions() }

    for i=#lines, 1, -1 do
        if lines[i]:GetObjectType() == "FontString" then
            table.insert(self.lines, lines[i]:GetText())
        end
    end
    local children = { frame:GetChildren() }

    for i=1, #children do
        self:ScrapeFrame(children[i])
    end

end

function CopyThat:OnTextChanged(this)
    if this:GetText() ~= self.str then
        this:SetText(self.str)
    end
    local s = CopyThatFrameScrollScrollBar
    this:GetParent():UpdateScrollChildRect()
    local _, m = s:GetMinMaxValues()
    if m > 0 and this.max ~= m then
        this.max = m
        s:SetValue(m)
    end
end

function CopyThat:Hide()
    CopyThatFrame:Hide()
end
