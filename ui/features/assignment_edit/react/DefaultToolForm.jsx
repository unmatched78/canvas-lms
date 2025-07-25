/*
 * Copyright (C) 2019 - present Instructure, Inc.
 *
 * This file is part of Canvas.
 *
 * Canvas is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, version 3 of the License.
 *
 * Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import $ from 'jquery'
import axios from '@canvas/axios'
import {useScope as createI18nScope} from '@canvas/i18n'
import PropTypes from 'prop-types'
import React, {useState, useEffect} from 'react'

import {Events as SelectContentDialogEvents} from '@canvas/select-content-dialog'
import usePostMessage from './hooks/usePostMessage'

import {Alert} from '@instructure/ui-alerts'
import {Button} from '@instructure/ui-buttons'
import {Flex} from '@instructure/ui-flex'
import {Text} from '@instructure/ui-text'
import {View} from '@instructure/ui-view'

const I18n = createI18nScope('DefaultToolForm')

const DefaultToolForm = ({
  toolUrl,
  courseId,
  toolName,
  previouslySelected,
  toolButtonText = I18n.t('Add Content'),
  toolInfoMessage = I18n.t('Click the button above to add content'),
  hideErrors = () => {},
}) => {
  const [launchDefinitions, setLaunchDefinitions] = useState([])
  const toolMessageData = usePostMessage('defaultToolContentReady')

  const defaultToolData = launchDefinitions.find(definition =>
    Object.values(definition.placements).find(placement => placement.url === toolUrl),
  )

  const contentTitle = () => {
    if (toolMessageData) {
      return toolMessageData.content && toolMessageData.content.title
    }
    return toolName
  }

  useEffect(() => {
    const fetchData = async () => {
      const result = await axios.get(
        `/api/v1/courses/${courseId}/lti_apps/launch_definitions?per_page=100&placements%5B%5D=assignment_selection&placements%5B%5D=resource_selection`,
      )
      setLaunchDefinitions(result.data)
    }
    fetchData()
  }, [courseId])

  useEffect(() => {
    $('#default-tool').data('tool', defaultToolData)
  }, [defaultToolData, launchDefinitions])

  const handleLaunchButton = event => {
    // clear any errors
    document.getElementById('default-tool-launch-button')?.classList.remove('error-outline')
    hideErrors('default-tool-launch-button_errors')
    SelectContentDialogEvents.onContextExternalToolSelect(event, $('#default-tool'))
  }

  if (!defaultToolData && launchDefinitions.length > 0) {
    return (
      <View display="block" padding="medium none small small">
        <Alert variant="error" margin="small small 0 0">
          <Text weight="bold">{I18n.t('Tool Not Found')}</Text>
          <br />
          <Text>{I18n.t('The tool is not installed in the course or account')}</Text>
        </Alert>
      </View>
    )
  }

  if (toolMessageData) {
    $.screenReaderFlashMessage(I18n.t('%{content} successfully added', {content: contentTitle()}))
  }

  return (
    <Flex direction="column" padding="medium none small none" width="100%">
      <Button
        id="default-tool-launch-button"
        name="default-tool-launch-button"
        onClick={handleLaunchButton}
        width="100%"
        textAlign="start"
      >
        {toolButtonText}
      </Button>
      <div id="default-tool-launch-button_errors"></div>

      {toolMessageData || previouslySelected ? (
        <Alert variant="success" margin="small small 0 0">
          <Text weight="bold">{contentTitle()}</Text>
          <br />
          <Text>{I18n.t('Successfully Added')}</Text>
        </Alert>
      ) : (
        <Alert variant="info" margin="small small 0 0">
          {toolInfoMessage}
        </Alert>
      )}

      {defaultToolData && (
        <div style={{display: 'none'}}>
          <ul className="tools">
            <li id="default-tool" className="tool resource_selection">
              {/* TODO: use InstUI button */}
              {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
              <a href="#" className="name">
                {defaultToolData.name}
              </a>
              <div className="description">This is a Sample Tool Provider.</div>
            </li>
          </ul>
        </div>
      )}
    </Flex>
  )
}

DefaultToolForm.propTypes = {
  toolUrl: PropTypes.string.isRequired,
  courseId: PropTypes.number.isRequired,
  toolName: PropTypes.string.isRequired,
  previouslySelected: PropTypes.bool.isRequired,
  toolButtonText: PropTypes.string,
  toolInfoMessage: PropTypes.string,
  hideErrors: PropTypes.func,
}

export default DefaultToolForm
