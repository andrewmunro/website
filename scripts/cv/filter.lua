-- pandoc lua filter to transform markdown to a custom latex cv format.

-- Global variables to track state
local company_details = {}
local section_open = false
local skip_header = true

-- Helper function to escape LaTeX characters
local function escape_latex(s)
    if not s then return '' end
    return s:gsub('&', '\\&')
            :gsub('%%', '\\%%')
            :gsub('#', '\\#')
            :gsub('_', '\\_')
end

-- Remove markdown formatting from text
local function clean_text(s)
    return s:gsub('%*%*', ''):gsub('%*', '')
end

-- Helper function to output pending company details as rSubsection
local function output_pending_details()
    if company_details.company then
        -- For entries without bullet points, use a simpler format
        local buffer = {
            '\\textbf{' .. company_details.company .. '} \\hfill {' .. company_details.dates .. '}',
            '\\\\',
            '\\textit{' .. company_details.title .. '} \\hfill \\textit{' .. company_details.location .. '}',
            '\\smallskip'
        }
        company_details = {}  -- Reset
        return pandoc.RawBlock('tex', table.concat(buffer, '\n'))
    end
    return nil
end

function Block(el)
    -- Skip horizontal rules
    if el.t == 'HorizontalRule' then
        return {}
    end
    
    -- Handle headers
    if el.t == 'Header' and el.level == 2 then
        local title = pandoc.utils.stringify(el.content)
        
        -- Skip the "Andrew Munro" header section
        if title:find("Andrew Munro") then
            return {}
        end
        
        -- Once we hit any other ## header, stop skipping
        skip_header = false
        
        -- Close previous section and open new one
        local result = {}
        
        -- Output any pending details before closing section
        local pending = output_pending_details()
        if pending then
            table.insert(result, pending)
        end
        
        if section_open then
            table.insert(result, pandoc.RawBlock('tex', '\\end{rSection}'))
        end
        
        local clean_title = escape_latex(clean_text(title))
        table.insert(result, pandoc.RawBlock('tex', '\\begin{rSection}{' .. clean_title .. '}'))
        section_open = true
        
        return result
    end
    
    -- Skip content in header section
    if skip_header then
        return {}
    end
    
    -- Job title header (level 3)
    if el.t == 'Header' and el.level == 3 then
        local result = {}
        
        -- Output any pending details before starting new entry
        local pending = output_pending_details()
        if pending then
            table.insert(result, pending)
        end
        
        local title = clean_text(pandoc.utils.stringify(el.content))
        company_details = { title = escape_latex(title) }
        
        return result
    end
    
    -- Handle paragraphs that could be company/education details
    if el.t == 'Para' then
        local content = pandoc.utils.stringify(el.content)
        
        -- Check if this is a job entry continuation (has title but no company yet)
        if company_details.title and not company_details.company then
            -- Extract company, location, and dates using pipe separator
            local company, location, dates = content:match('^([^|]+)|([^|]+)|(.+)$')
            
            if company and location and dates then
                company_details.company = escape_latex(clean_text(company:match('^%s*(.-)%s*$')))
                company_details.location = escape_latex(clean_text(location:match('^%s*(.-)%s*$')))
                company_details.dates = escape_latex(clean_text(dates:match('^%s*(.-)%s*$')))
            end
            return {}
        end
        
        -- For other paragraphs, output pending details if any
        local result = {}
        local pending = output_pending_details()
        if pending then
            table.insert(result, pending)
            table.insert(result, el)  -- Include the current paragraph
            return result
        end
    end
    
    -- Handle bullet lists
    if el.t == 'BulletList' then
        -- Job/Education responsibilities bullet list (has company info)
        if company_details.company then
            local buffer = {
                '\\begin{rSubsection}{' .. company_details.title .. '}{' .. 
                company_details.dates .. '}{' .. company_details.company .. '}{' .. 
                company_details.location .. '}'
            }
            
            -- Add bullet points
            for _, item in ipairs(el.content) do
                local item_text = escape_latex(pandoc.utils.stringify(item))
                table.insert(buffer, '\\item ' .. item_text)
            end
            
            table.insert(buffer, '\\end{rSubsection}')
            
            -- Reset for next job
            company_details = {}
            
            return pandoc.RawBlock('tex', table.concat(buffer, '\n'))
        else
            -- Section bullet lists (like CORE COMPETENCIES) - use compact list
            local buffer = {
                '\\begin{list}{$\\cdot$}{\\leftmargin=0em}',
                '\\setlength{\\itemsep}{-0.5em}'
            }
            
            -- Add bullet points
            for _, item in ipairs(el.content) do
                local item_text = escape_latex(pandoc.utils.stringify(item))
                table.insert(buffer, '\\item ' .. item_text)
            end
            
            table.insert(buffer, '\\end{list}')
            
            return pandoc.RawBlock('tex', table.concat(buffer, '\n'))
        end
    end
    
    -- Return unchanged for other elements
    return el
end

-- Close any open section at document end
function Pandoc(doc)
    local blocks = doc.blocks
    
    -- Output any final pending details
    local pending = output_pending_details()
    if pending then
        table.insert(blocks, pending)
    end
    
    if section_open then
        table.insert(blocks, pandoc.RawBlock('tex', '\\end{rSection}'))
    end
    return doc
end 